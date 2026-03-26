import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../widgets/device_card.dart';

class RoomScreen extends StatelessWidget {
  final String roomId;
  
  const RoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    // Watch provider to react to changes
    final provider = Provider.of<HomeProvider>(context);
    final devices = provider.getDevicesByRoom(roomId);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // slightly lighter than main
      appBar: AppBar(
        title: Text(
          roomId.replaceAll('_', ' ').toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: devices.isEmpty 
          ? Center(child: Text("No devices found in this room", style: TextStyle(color: Colors.grey)))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9, // Taller cards
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return DeviceCard(
                  device: device,
                  onTap: () => provider.toggleDevice(device.id),
                );
              },
            ),
    );
  }
}
