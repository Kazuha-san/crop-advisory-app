import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(FarmerApp());
}


const String BASE_URL = "https://crop-advisory-app.onrender.com";

class FarmerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farming App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: WelcomeScreen(),
    );
  }
}

// ================= Welcome Screen =================
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _selectedLang = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 16,
            child: DropdownButton<String>(
              value: _selectedLang,
              items: ["English", "Hindi", "Punjabi"]
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() => _selectedLang = val!);
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 200,
                  color: Colors.green.shade200,
                  child: const Center(child: Text("Logo Here")),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () async {
                    try {
                      Position pos = await Geolocator.getCurrentPosition();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainHomePage(
                            initialPosition: pos,
                          ),
                        ),
                      );
                    } catch (e) {
                      print("GPS permission denied: $e");
                    }
                  },
                  child: const Text("Login", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= Main Home Page =================
class MainHomePage extends StatefulWidget {
  final Position initialPosition;
  MainHomePage({required this.initialPosition});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final data = await fetchWeather(widget.initialPosition.latitude, widget.initialPosition.longitude);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      print("Weather fetch error: $e");
      setState(() {
        _weatherData = {'temp': '--', 'description': 'Connect to Internet to view weather'};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      DashboardScreen(weatherData: _weatherData),
      const Center(child: Text("Calendar (Under Dev)")),
      const Center(child: Text("Pest & Disease (Under Dev)")),
      const Center(child: Text("Personalize (Under Dev)")),
      const Center(child: Text("Profile (Under Dev)")),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Smart Farming Assistant")),
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.smart_toy, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.bug_report), label: "Pest"),
          BottomNavigationBarItem(icon: Icon(Icons.tune), label: "Personalize"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// ================= Dashboard =================
class DashboardScreen extends StatelessWidget {
  final Map<String, dynamic>? weatherData;
  DashboardScreen({this.weatherData});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
          child: ListTile(
            leading: Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
            title: Text("Weather Today"),
            subtitle: Text("${weatherData?['temp'] ?? '--'}°C, ${weatherData?['description'] ?? 'Loading...'}"),
          ),
        ),
        _infoCard(Icons.store, Colors.blue, "Market Prices", "Wheat: ₹2200/quintal\nCotton: ₹6000/quintal (Under Development)"),
        _infoCard(Icons.article, Colors.green, "Govt. Policies & News", "Latest updates from ICAR, PAU, Govt. schemes (Under Development)"),
      ],
    );
  }

  Widget _infoCard(IconData icon, Color color, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

// ================= Backend Fetch =================
Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
  try {
    final response = await http.get(Uri.parse("$BASE_URL/weather?lat=$lat&lon=$lon"));
    if (response.statusCode == 200) return jsonDecode(response.body);
    return {'temp': '--', 'description': 'Failed to load'};
  } catch (e) {
    return {'temp': '--', 'description': 'Connect to Internet to view weather'};
  }
}
