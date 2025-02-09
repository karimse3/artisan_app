import 'package:flutter/material.dart';
import 'professionnels.dart';

class AccueilScreen extends StatefulWidget {
  //final String professionelId;
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  // Liste des catégories avec des icônes et des titres
  final List<Map<String, dynamic>> categories = [
    {"id":"1","title": "Plombier", "icon": Icons.plumbing},
    {"id":"2", "title": "Électricien", "icon": Icons.electrical_services},
    {"id":"3","title": "Jardinier", "icon": Icons.grass},
    {"id":"4","title": "Ménager", "icon": Icons.cleaning_services},
    {"id":"5","title": "Menuisier", "icon": Icons.handyman},
    {"id":"6","title": "Peintre", "icon": Icons.format_paint},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text("Categories de services", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Nombre de colonnes dans la grille
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // Naviguer vers la page des professionnels
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListProfessionnels(
                      categoryTitle: category['title'],
                      // professionelId:professionelId,
                    ),
                  ),
                );
              },
              child: Card(
                color: Color(0xEDDBEBFF),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'],
                      size: 50,
                      color: const Color(0xED0088FF),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFFFFFFF),// couleur de la page// couleur arrière plan de la page
    );
  }
}
