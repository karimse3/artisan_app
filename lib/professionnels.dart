import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'avis.dart';
import 'reservation.dart';

class ListProfessionnels extends StatefulWidget {
  final String categoryTitle;

  const ListProfessionnels({super.key, required this.categoryTitle});

  @override
  State<ListProfessionnels> createState() => _ListProfessionnelsState();
}

class _ListProfessionnelsState extends State<ListProfessionnels> {
  bool isSearching = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          decoration: const InputDecoration(
            hintText: 'Rechercher...',
            border: InputBorder.none,
          ),
          onChanged: (query) {
            setState(() {
              searchQuery = query.toLowerCase();
            });
          },
        )
            : Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              size: 28,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) searchQuery = '';
              });
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 28,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xED0088FF),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('professionels')
            .where('categorie', isEqualTo: widget.categoryTitle)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Aucun professionnel trouvé pour cette catégorie.'),
            );
          }

          final professionels = snapshot.data!.docs.where((professionel) {
            final name =
            '${professionel['prenom']} ${professionel['nom']}'.toLowerCase();
            return name.contains(searchQuery);
          }).toList();

          return ListView.builder(
            itemCount: professionels.length,
            itemBuilder: (context, index) {
              final professionel = professionels[index];
              final professionelId = professionel.id;
              final prenom = professionel['prenom'];
              final nom = professionel['nom'];
              final rating = professionel['note']?.toDouble() ?? 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                child: Card(
                  color: Colors.white,
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prenom,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RatingBar.builder(
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 25,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Color(0xFFF29D38),
                              ),
                              onRatingUpdate: (newRating) {
                                FirebaseFirestore.instance
                                    .collection('professionels')
                                    .doc(professionelId)
                                    .update({'note': newRating});
                              },
                            ),
                          ],
                        ),
                        Text(
                          nom,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.categoryTitle,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReservationPage(
                                      professionelId: professionelId,
                                      prenom: prenom,
                                      nom: nom,
                                      categorie: widget.categoryTitle,
                                    ),
                                  ),
                                );
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Color(0xED0088FF),
                                ),
                              ),
                              child: const Text(
                                'Réserver',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                            const SizedBox(width: 8.0), // تقليل المسافة بين الأزرار
                            ElevatedButton(
                              onPressed: () {
                                // Add your message functionality here
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Color(0xED0088FF),
                                ),
                              ),
                              child: const Text(
                                'Message',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AvisClient(
                                      professionelId: professionelId,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Avis client',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: const Color(0xFFF2F3F4),
    );
  }
}
