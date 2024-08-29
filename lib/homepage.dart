import 'package:flutter/material.dart';
import 'university_selection_page.dart'; // Import the new page where universities will be selected

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Define a Map to associate each city with its list of universities
  final Map<String, List<String>> cityUniversities = {
    'Chennai': ['Shiv Nadar University', 'SRM University', 'VIT University'],
    'Hyderabad': ['VIT University', 'IIT Hyderabad'],
    'Bangalore': ['Indian Institute of Science', 'Christ University', 'Jain University'],
    'Delhi': ['IIT Delhi', 'Delhi University'],
    'Kolkata': ['Advanced College of Management', 'Amrita University'],
  };

  final List<String> pictures = [
    'https://live.staticflickr.com/6237/6336917600_dd20e4f10b_b.jpg',
    'https://cdn.wrytin.com/images/wrytup/r/1024/screenshot-2054--jw666soi.jpeg',
    'https://images.yourstory.com/production/document_image/mystoryimage/4h0ck631-Vidhana_Souda_,_Bangalore.jpg?fm=png&auto=format',
    'https://www.travelescape.in/wp-content/uploads/2018/07/ccimage-eb36b80b2ffc053ecd0b470de7444e90fe76e7d619b914469df8c9-1-scaled.jpg',
    'https://wallpaperaccess.com/full/1896134.jpg'
  ];

  String filter = '';

  void _filterCities(String query) {
    setState(() {
      filter = query;
    });
  }

  List<String> get filteredCities {
    return cityUniversities.keys.where((city) => city.toLowerCase().contains(filter.toLowerCase())).toList();
  }

  void _navigateToUniversitiesPage(String city) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniversitySelectionPage(city: city, universities: cityUniversities[city]!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 221, 251),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Select a city',
                    style: TextStyle(
                           color: Colors.black,
                           fontSize: 30.0,
                           fontWeight: FontWeight.bold,
                    ),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Type a City Name...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterCities,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 2.0,
              ),
              itemCount: filteredCities.length,
              itemBuilder: (context, index) {
                String city = filteredCities[index];
                int pictureIndex = cityUniversities.keys.toList().indexOf(city);
                return GestureDetector(
                  onTap: () {
                    _navigateToUniversitiesPage(city); // Navigate to universities page
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(pictures[pictureIndex]),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                      ),
                    ),
                    child: Text(
                      city,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
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
