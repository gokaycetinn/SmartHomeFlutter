import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _ipController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadIp();
  }

  Future<void> _loadIp() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ipController.text = prefs.getString('rpi_ip') ?? '192.168.1.100';
    });
  }

  Future<void> _saveIp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rpi_ip', _ipController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('IP Address Saved!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Raspberry Pi Connection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            TextField(
              controller: _ipController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'IP Address',
                labelStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                prefixIcon: Icon(Icons.wifi, color: Colors.blueAccent),
                helperText: 'Enter the IP address of your Raspberry Pi',
                helperStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF2A2A35),
              ),
              keyboardType: TextInputType.datetime, // Optimizes keyboard for IP entry (dots and numbers)
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveIp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text('Save Connection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            
            SizedBox(height: 40),
            Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ListTile(
              leading: Icon(Icons.info, color: Colors.white),
              title: Text('Version', style: TextStyle(color: Colors.white)),
              trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
