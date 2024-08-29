import 'package:flutter/material.dart';
import 'lab_devices_page.dart'; // Import the new devices page where devices will be displayed

class UniversityLabsPage extends StatelessWidget {
  final String universityName;

  UniversityLabsPage({required this.universityName});

  // Example list of labs for the university (replace with your actual data)
  final List<String> labs = [
    'IoT Lab',
    'Cognizant Lab',
    'Computer Lab',
    'Language Lab',
  ];

  // Placeholder image URL for the university (replace with actual image URL)
  final String universityImageUrl = 'https://global-uploads.webflow.com/5fa429174cc2b89c3d4b6bd4/603613f02acc65cc319926e7_Kudelski-IoT-Security-Design-Lab-2-Laser-Fault-Injection.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          '$universityName Labs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Add university image
          Image.network(
            universityImageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20), // Add padding between the image and the grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns grid
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 2.0, // Aspect ratio for each item
              ),
              itemCount: labs.length,
              itemBuilder: (context, index) {
                String labName = labs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LabDevicesPage(labName: labName),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Color.fromARGB(255, 199, 223, 243), // Light blue background
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          labName,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black, // Dark blue text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
