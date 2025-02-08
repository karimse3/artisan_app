import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvisClient extends StatefulWidget {
  final String professionelId;

  const AvisClient({super.key, required this.professionelId});

  @override
  _AvisClientState createState() => _AvisClientState();
}

class _AvisClientState extends State<AvisClient> {
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitReview() async {
    await FirebaseFirestore.instance.collection('avis').add({
      'professionelId': widget.professionelId,
      'review': _reviewController.text,
      'date': Timestamp.now(),
    });
    Navigator.pop(context);  // Close the review page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avis client' , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xED0088FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _reviewController,
              decoration: const InputDecoration(labelText: 'Écrire votre avis'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Color(0xED0088FF),
                ),
              ),
              child: const Text('Envoyer l\'avis', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
