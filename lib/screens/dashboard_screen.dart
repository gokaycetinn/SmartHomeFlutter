import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/home_provider.dart';
import '../models/device_model.dart';
import '../widgets/device_card.dart';
import 'mapping_screen.dart';
import 'settings_screen.dart';
import 'room_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const RoomsListScreen(), // Placeholder
    const MappingScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E2C),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.meeting_room), label: 'Rooms'),
          BottomNavigationBarItem(icon: Icon(Icons.gesture), label: 'Mappings'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      if (provider.devices.isEmpty && !provider.isLoading) {
        provider.loadDevices();
        provider.startEventPolling();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Home,', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      Text('Gokay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.person, color: Colors.white),
                    radius: 25,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Weather Widget
            FadeInDown(
              delay: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cloudy', style: TextStyle(color: Colors.white, fontSize: 18)),
                        Text('24°C', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        Text('March 25, 2026', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Icon(Icons.cloud, color: Colors.white, size: 50),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Last Event Widget
            if (provider.lastEvent != null)
              FadeInUp(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.deepPurpleAccent),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.deepPurpleAccent),
                      const SizedBox(width: 10),
                      Text(
                        'Detected: ${provider.lastEvent!.name.toUpperCase()}',
                        style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text('Just now', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),

             // Rooms (Horizontal list)
            Text('Rooms', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.rooms.length,
                itemBuilder: (context, index) {
                  final room = provider.rooms[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoomScreen(roomId: room))),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A35), // Default inactive
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Center(child: Text(room.toUpperCase(), style: TextStyle(color: Colors.white))),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Devices Grid
            Text('Favorite Devices', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            provider.isLoading 
              ? Center(child: CircularProgressIndicator()) 
              : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: provider.devices.length,
              itemBuilder: (context, index) {
                final device = provider.devices[index];
                return DeviceCard(
                  device: device,
                  onTap: () => provider.toggleDevice(device.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

 extends StatelessWidget {
  const RoomsListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final rooms = provider.rooms;

    return Scaffold(
      appBar: AppBar(title: Text('All Rooms'), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          final deviceCount = provider.getDevicesByRoom(room).length;
          
          return Card(
            color: const Color(0xFF2A2A35),
            margin: EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.2), shape: BoxShape.circle),
                child: Icon(Icons.meeting_room, color: Colors.blueAccent),
              ),
              title: Text(room.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              subtitle: Text('$deviceCount Devices', style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoomScreen(roomId: room))),
            ),
          );
        },
      ),
    );
  }
}
