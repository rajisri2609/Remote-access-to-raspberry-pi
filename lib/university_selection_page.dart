import 'package:flutter/material.dart';
import 'university_labs_page.dart'; // Import the new labs page where labs will be displayed

class UniversitySelectionPage extends StatelessWidget {
  final String city;
  final List<String> universities;

  UniversitySelectionPage({required this.city, required this.universities});

  // Define a Map to associate each university with its image URL
  final Map<String, String> universityImages = {
    'Shiv Nadar University': 'https://mli4sjv4v3cg.i.optimole.com/VIYEva8.EXct~4ba44/w:auto/h:auto/q:66/https://startupreporter.in/wp-content/uploads/2021/09/ShivNadarUniversityLogo-a641796f.jpg',
    'SRM University': 'https://logodix.com/logo/1787067.png',
    'VIT University': 'https://vit.ac.in/files/Biomet2018/img/vit_logo.jpg',
    'IIT Hyderabad': 'https://example.com/iit_hyderabad.jpg',
    'Indian Institute of Science': 'https://example.com/iisc.jpg',
    'Christ University': 'https://example.com/christ.jpg',
    'Jain University': 'https://example.com/jain.jpg',
    'IIT Delhi': 'https://example.com/iit_delhi.jpg',
    'Delhi University': 'https://example.com/delhi_university.jpg',
    'Advanced College of Management': 'https://example.com/advanced_college.jpg',
    'Amrita University': 'https://example.com/amrita.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('$city Universities',style: TextStyle(
                           color: Colors.black,
                           fontSize: 25.0,
                           fontWeight: FontWeight.bold,
                    ),),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // Single column grid
          mainAxisSpacing: 13.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 3.0, // Aspect ratio for each item
        ),
        itemCount: universities.length,
        itemBuilder: (context, index) {
          String universityName = universities[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UniversityLabsPage(universityName: universityName),
                ),
              );
            },
            child: Card(
              elevation: 5.0,
              shadowColor: Colors.blue,
              
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Add university image
                    Image.network(
                      universityImages[universityName] ?? 'https://example.com/default.jpg',
                      width: 150,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    // University name
                    Expanded(
                      child: Text(
                        universityName,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 4, 9),
                        ),
                      ),
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
