import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String backendUrl = 'http://127.0.0.1:5000/send-operation'; // Use 10.0.2.2 for Android emulator

class ChatScreen extends StatefulWidget {
  final String deviceName;

  ChatScreen({required this.deviceName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  List<Map<String, dynamic>> messages = []; // List to hold chat messages
  TextEditingController messageController = TextEditingController();
  String deviceAbout = '';
  List<String> commandCategories = ['Package Management', 'System Control', 'System Information']; // Example command categories
  List<List<String>> commands = [
    ['sudo apt update', 'sudo apt upgrade', 'sudo apt install <package>', 'sudo apt remove <package>'],
    ['sudo reboot', 'sudo shutdown now'],
    ['uname -a', 'df -h', 'free -h'],
  ]; // Example commands for each category
  List<String> currentCommands = []; // List to hold current commands for the selected category
  String selectedCommand = ''; // Hold the selected command

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: commandCategories.length, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    _fetchDeviceStatus('details');
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      currentCommands = commands[_tabController!.index];
    });
  }

  void _fetchDeviceStatus(String message) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'selectedOperation': message,
          'selectedDevice': widget.deviceName,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          deviceAbout = responseBody['response'];
        });
      } else {
        print('Failed to fetch device details. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching device status: $error');
    }
  }

  void sendMessage(String message) {
    // Add the sent message to the list
    setState(() {
      messages.add({'text': message, 'isMe': true});
    });

    // Clear the selectedCommand so it doesn't appear as a suggestion after sending
    setState(() {
      selectedCommand = '';
    });

    // Send the message to the backend server
    sendOperationToServer(message, widget.deviceName);

    // Clear message input field
    messageController.clear();
  }

  Future<void> sendOperationToServer(String message, String deviceName) async {
    try {
      // Send a POST request to the backend server
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'selectedOperation': message,
          'selectedDevice': deviceName,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final serverResponse = responseBody['response'];

        // Update the UI with the server response
        setState(() {
          messages.add({
            'text': serverResponse,
            'isMe': false,
          });
        });
      } else {
        print('Failed to send operation. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending operation: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.deviceName} Chat',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              deviceAbout,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Static box with initial message
          Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              'Remote connection established. Enter commands to execute',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: message['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75, // 75% of screen width
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: message['isMe'] ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        message['text'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.blue,
                  child: TabBar(
                    controller: _tabController,
                    tabs: commandCategories
                        .map((category) => Tab(
                              text: category,
                            ))
                        .toList(),
                    indicatorColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: commandCategories.map((category) {
                      final categoryIndex = commandCategories.indexOf(category);
                      return GridView.builder(
                        shrinkWrap: true, // Ensure GridView does not occupy extra space
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: commands[categoryIndex].length,
                        itemBuilder: (context, index) {
                          final command = commands[categoryIndex][index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedCommand = command;
                                messageController.text = command; // Set selected command in text field
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: selectedCommand == command ? Colors.blue : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Center(
                                child: Text(
                                  command,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: selectedCommand == command ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a command...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onChanged: (value) {
                            selectedCommand = value;
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          sendMessage(selectedCommand);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
