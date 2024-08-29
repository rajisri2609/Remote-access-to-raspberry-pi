import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_screen.dart'; 


const String backendUrl = 'http://127.0.0.1:5000/send-operation'; // Use 10.0.2.2 for Android emulator

class LabDevicesPage extends StatefulWidget {
  final String labName;

  LabDevicesPage({required this.labName});

  @override
  _LabDevicesPageState createState() => _LabDevicesPageState();
}

class _LabDevicesPageState extends State<LabDevicesPage> {
  // Example list of devices for the lab (replace with your actual data)
  final List<Map<String, dynamic>> devices = [
    {'name': 'Raspberry_Pi_1', 'icon': Icons.computer, 'status': 'offline'},
    {'name': 'Linux_1', 'icon': Icons.desktop_windows, 'status': 'offline'},
    {'name': 'Android_Device_1', 'icon': Icons.phone_android, 'status': 'offline'},
    {'name': 'Windows_PC_1', 'icon': Icons.computer, 'status': 'offline'},
    {'name': 'Printer_1', 'icon': Icons.print, 'status': 'offline'},
    {'name': 'Scanner_1', 'icon': Icons.scanner, 'status': 'offline'},
    {'name': 'Router_1', 'icon': Icons.router, 'status': 'offline'},
    {'name': 'Camera_1', 'icon': Icons.camera, 'status': 'offline'},
  ];
  /*  @override
  void initState() {
    super.initState();
    _fetchDeviceStatus('status');
  }

  void _fetchDeviceStatus(String message) async {
    for (var device in devices) {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'selectedOperation': message,
          'selectedDevice': device['name'],
        }),
      );

      if (response.statusCode == 200) {
        final statusData = jsonDecode(response.body);
        setState(() {
          device['status'] = statusData['response'] ?? 'offline';
        });
      } else {
        print('Failed to fetch status for ${device['name']}: ${response.statusCode}');
        setState(() {
          device['status'] = 'offline';
        });
      }
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          '${widget.labName} Devices',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns grid
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1.0, // Aspect ratio for each item (square)
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          String deviceName = devices[index]['name'];
          IconData deviceIcon = devices[index]['icon'];
          String deviceStatus = devices[index]['status'];
          Color statusColor = deviceStatus == 'online' ? Colors.green : Colors.red;

          return GestureDetector(
            onTap: () {
              // Navigate to ChatScreen when device is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(deviceName: deviceName),
                ),
              );
            },
            child: Card(
              elevation: 15.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(deviceIcon, size: 48.0), // Icon with specified size
                    SizedBox(height: 8.0),
                    Flexible(
                      child: Text(
                        deviceName,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2, // Adjust as needed
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      deviceStatus,
                      style: TextStyle(color: statusColor, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
