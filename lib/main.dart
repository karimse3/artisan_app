import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'accueil.dart';
import 'login.dart';
import 'singup.dart';
import 'historique_reservation.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAZNDE1qN-Y9rYTd6sPcpEzZLgenbfFhIA",
      authDomain: "first-d14cd.firebaseapp.com",
      projectId: "first-d14cd",
      storageBucket: "first-d14cd.firebasestorage.app",
      messagingSenderId: "1041387356876",
      appId: "1:1041387356876:web:5c6aeafe647f4df268b869",
      measurementId: "G-3CQ7041Y20",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artisan app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signUp': (context) => const SignUpScreen(),
        '/accueil': (context) => const AccueilScreen(),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const AccueilScreen(),
    const ReservationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Réservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
