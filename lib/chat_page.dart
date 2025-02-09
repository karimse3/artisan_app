import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String professionelId;
  final String professionelName;

  const ChatPage({super.key, required this.professionelId, required this.professionelName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> messages = [];


  final Map<String, String> autoResponses = {
    "bonjour": "Bonjour ! Comment puis-je vous aider ?",
    "prix": "Les prix varient en fonction du service. Pouvez-vous préciser votre besoin ?",
    "disponible": "Je suis disponible en semaine de 9h à 18h. Quel jour vous convient ?",
    "réservation": "Vous pouvez réserver un service via le bouton 'Réserver'.",
  };

  void sendMessage(String text) {
    setState(() {
      messages.add({"sender": "user", "text": text});
    });


    String? response;
    autoResponses.forEach((key, value) {
      if (text.toLowerCase().contains(key)) {
        response = value;
      }
    });


    if (response != null) {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          messages.add({"sender": "bot", "text": response!});
        });
      });
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat avec ${widget.professionelName}"),
        backgroundColor: Color(0xED0088FF),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message["sender"] == "user";

                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message["text"]!,
                      style: TextStyle(fontSize: 16, color: isUserMessage ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Écrire un message...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xED0088FF)),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      sendMessage(_messageController.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
