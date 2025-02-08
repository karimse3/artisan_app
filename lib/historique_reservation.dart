import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    // Vérifiez si l'utilisateur est connecté
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mes réservations"),
          backgroundColor: const Color(0xED0088FF),
        ),
        body: const Center(child: Text('Veuillez vous connecter pour voir vos réservations.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Supprime le bouton de retour
        title: const Center(
          child: Text("Mes réservations",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ),
        backgroundColor: const Color(0xED0088FF),// couleur app Bar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .orderBy('dateTime')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Aucune réservation trouvée.'));
          }
          // Filtrer localement les réservations en fonction de l'utilisateur actuel
          final reservations = snapshot.data!.docs.where((reservation) {
            return reservation['clientId'] == user.uid;
          }).toList();

          if (reservations.isEmpty) {
            return const Center(child: Text('Aucune réservation trouvée.'));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              final dateTime = (reservation['dateTime'] as Timestamp).toDate();
              String statut = 'en attente';
              final prenom = reservation['prenom'];
              final nom = reservation['nom'];
              final categorie = reservation['categorie'];


              return SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                        color:Colors.white,
                        elevation: 1.0,
                        child: SizedBox(
                            height:100,
                            width:double.infinity,
                            child:Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children:[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            // prenom et nom du professionel
                                            Row(
                                              children: [
                                                Text(prenom, style:const TextStyle(fontWeight:FontWeight.bold)),
                                                const SizedBox(width:10.0),
                                                Text(nom, style:const TextStyle(fontWeight:FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Text('Statut', style:TextStyle(fontWeight:FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  // categorie
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0,right:8.0),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(categorie, style:const TextStyle(color:Colors.grey)),
                                        Text(statut, style:const TextStyle(color:Colors.blue)),

                                      ],
                                    ),
                                  ),
                                  // date et heure de la réservation
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Text("Réserver le:"),
                                        const SizedBox(width:10.0),
                                        Text('${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                                            style:const TextStyle(fontWeight:FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ]
                            )
                        )
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      backgroundColor: const Color(0XFFF2F3F4),// couleur de la page
    );
  }
}