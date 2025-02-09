import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_auth_services.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isVisible = true;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/logo.png",
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_prenomController, "Entrer votre prénom", Icons.person_outlined),
                    _buildTextField(_nomController, "Entrer votre nom", Icons.person_outlined),
                    _buildTextField(_emailController, "Entrer votre email", Icons.email_outlined, isEmail: true),
                    _buildTextField(_telephoneController, "Entrer votre numéro de téléphone", Icons.phone_android_outlined, isPhone: true),
                    _buildPasswordField(_passwordController, "Entrer votre mot de passe"),
                    _buildPasswordField(_confirmPasswordController, "Confirmer votre mot de passe", confirmPassword: true),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUp,
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Color(0xED0088FF)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("S'INSCRIRE", style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    _buildLoginLink(),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final User? user = await _authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (user != null && mounted) {
        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Le compte a été créé avec succès ! Vous allez être redirigé vers la page de connexion...",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );


        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("erreur : ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      IconData icon, {bool isEmail = false, bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        validator: (value) {
          if (value == null || value.isEmpty) return "Ce champ est obligatoire.";

          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Veuillez entrer une adresse e-mail valide';
          }

          if (isPhone) {
            String phone = value.replaceAll(RegExp(r'\s+'), '');
            if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
              return 'Le numéro doit contenir exactement 10 chiffres';
            }
          }

          return null;
        },
        decoration: _inputDecoration(label, icon),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, {bool confirmPassword = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        obscureText: _isVisible,
        validator: (value) {
          if (value!.isEmpty) return "Ce champ est obligatoire.";
          if (!confirmPassword && value.length < 6) return "Le mot de passe doit contenir au moins 6 caractères.";
          if (confirmPassword && value != _passwordController.text) return "Les mots de passe ne correspondent pas.";
          return null;
        },
        decoration: _inputDecoration(label, Icons.lock_outline, isPassword: true),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, {bool isPassword = false}) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blue),
      ),
      labelText: label,
      suffixIcon: isPassword
          ? InkWell(
        onTap: () => setState(() => _isVisible = !_isVisible),
        child: Icon(_isVisible ? Icons.visibility_off : Icons.visibility),
      )
          : null,
    );
  }

  Widget _buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Vous avez déjà un compte ?"),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/"),
            child: const Text("Se connecter", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}