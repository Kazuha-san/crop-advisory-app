// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(FarmerApp());
}

class FarmerApp extends StatelessWidget {
  const FarmerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Crop Advisory App',
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
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _selectedLang = "English";

  Future<Position?> _getPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint("GPS not available: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= Hamburger Drawer =================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Set Location'),
              onTap: () {
                // Add set location logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {
                // Add feedback logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                // Add help logic here
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                // Add about logic here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.language, color: Colors.green),
                ),
                initialValue: _selectedLang,
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
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/fnl (1).png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    Position? pos = await _getPosition();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainHomePage(initialPosition: pos)),
                    );
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
  final Position? initialPosition;
  const MainHomePage({super.key, this.initialPosition});

  @override
  _MainHomePageState createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardScreen(),
      const Center(child: Text("(Under Development)")),
      const Center(child: Text("(Under Development)")),
      const Center(child: Text("(Under Development)")),
      const Center(child: Text("(Under Development)")),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Farming Assistant"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color.fromARGB(255, 81, 215, 132)),
              child: Text('MENU', style: TextStyle(color: Colors.white, fontSize: 56)),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Set Location'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 71, 175, 84),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ChatBotScreen()));
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 21, 156, 66),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Calendar"),
          BottomNavigationBarItem(icon: Icon(Icons.agriculture), label: "Features"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Personalize"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
    );
  }
}

// ================= Dashboard =================
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _dashboardCard(Icons.wb_sunny, Colors.orange, "Weather Today",
            "28°C, Sunny (Demo Data)"),
        _dashboardCard(Icons.store, Colors.blue, "Market Prices",
            "Wheat: ₹2200/quintal\nCotton: ₹6000/quintal (Demo Data)"),
        _dashboardCard(Icons.article, Colors.green, "Govt. Policies & News",
            "Latest updates from ICAR, PAU, Govt. schemes (Demo Data)"),
      ],
    );
  }

  Widget _dashboardCard(
      IconData icon, Color color, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: color, size: 45),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16)),
        tileColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

// ================= Chatbox =================
class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({"sender": "You", "text": _controller.text});
      _messages.add({"sender": "Bot", "text": "This is a demo reply."});
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  final isUser = msg["sender"] == "You";
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.green.shade200 : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(msg["text"]!, style: const TextStyle(fontSize: 16)),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            // Fixed height input area with extra bottom padding
            Container(
              height: 80, // increased height
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              color: const Color.fromARGB(255, 197, 231, 205),
              child: Row(
                children: [
                  // + button
                  GestureDetector(
                    onTap: () {
                      // Add attachment logic here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade400,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Text field
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _isTyping ? _sendMessage() : null,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Dynamic voice/send button
                  GestureDetector(
                    onTap: _isTyping ? _sendMessage : () {
                      // Voice input logic
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade400,
                      ),
                      child: Icon(
                        _isTyping ? Icons.send : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



