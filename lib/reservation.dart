import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReservationPage extends StatefulWidget {
  final String professionelId;
  final String prenom;
  final String nom;
  final String categorie;

  const ReservationPage({
    super.key,
    required this.professionelId,
    required this.prenom,
    required this.nom,
    required this.categorie,
  });

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prenomClientController = TextEditingController();
  final TextEditingController _nomClientController = TextEditingController();
  final TextEditingController _adresseClientController =
  TextEditingController();
  final TextEditingController _emailClientController = TextEditingController();
  final TextEditingController _phoneClientController = TextEditingController();
// récupérer l'utilisateur actuelle ou connecté
  final User? user = FirebaseAuth.instance.currentUser;

// fonction date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

// fonction heure
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }

// fonction de l'envoi d'un réservation
  Future<void> _submitReservation() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Veuillez sélectionner une date et une heure')),
        );
        return;
      }

      try {
        // Combiner la date et l'heure sélectionnées
        final DateTime reservationDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        // Créer une nouvelle réservation dans Firestore
        await FirebaseFirestore.instance.collection('reservations').add({
          'professionelId': widget.professionelId,
          'clientId': user!.uid, // utilisateur actuelle
          'prenom': widget.prenom,
          'nom': widget.nom,
          'categorie': widget.categorie,
          'prenomClient': _prenomClientController.text.trim(),
          'nomClient': _nomClientController.text.trim(),
          'adresseClient': _adresseClientController.text.trim(),
          'phoneClient': _phoneClientController.text.trim(),
          'emailClient': _emailClientController.text.trim(),
          'dateTime': reservationDateTime,
          'description': _descriptionController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Réservation réussie!',
              style:TextStyle(color:Colors.white,
                  fontSize:12.0,fontWeight:FontWeight.bold)),
            backgroundColor: Colors.green,
          ),

        );

        Navigator.pop(context); // Retourner à la page précédente
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la réservation!',
              style:TextStyle(color:Colors.white,
                  fontSize:12.0,fontWeight:FontWeight.bold)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réserver ${widget.prenom} ${widget.nom}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              size: 28, color: Colors.white), // Icône de retour
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
        backgroundColor: const Color(0xED0088FF), // couleur app Bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // formulaire de réservation
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // champ prénom
                TextFormField(
                  controller: _prenomClientController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Entrer votre prénom";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    labelText: "Entrer votre prénom",
                  ),
                ),
                const SizedBox(height: 10),
                // champ nom
                TextFormField(
                  controller: _nomClientController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Entrer votre nom";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    labelText: "Entrer votre nom",
                  ),
                ),
                const SizedBox(height: 10),
                // champ adresse
                TextFormField(
                  controller: _adresseClientController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Entrer votre adresse";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.map_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    labelText: "Entrer votre adresse",
                  ),
                ),
                const SizedBox(height: 10),
                // champ téléphone
                TextFormField(
                  controller: _phoneClientController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],//prendre que des chiffres
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Entrer votre numéro de téléphone";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    labelText: "Entrer votre numéro de téléphone",
                  ),
                ),
                const SizedBox(height: 10),
                // champ email
                TextFormField(
                  controller: _emailClientController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Entrer votre email";
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Entrer un e-mail valide';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    labelText: "Entrer votre email",
                  ),
                ),
                // Sélection de la Date
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_selectedDate == null
                      ? 'Sélectionnez une date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                  onTap: () => _selectDate(context),
                ),
                // Sélection de l'Heure
                ListTile(
                  leading: const Icon(Icons.access_time),
                  title: Text(_selectedTime == null
                      ? 'Sélectionnez une heure'
                      : _selectedTime!.format(context)),
                  onTap: () => _selectTime(context),
                ),
                // Description (optionnelle)
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: Color(0xED0088FF), width: 1.0)),
                    labelText: "Décrivez votre besoin",

                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitReservation,
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Color(0xED0088FF)),
                  ),
                  child: const Text(
                    'Confirmer la Réservation',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0XFFFFFFFF),// couleur de la page
    );
  }
}
