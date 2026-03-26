import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../models/mapping_model.dart';
import '../models/device_model.dart';

class MappingScreen extends StatefulWidget {
  const MappingScreen({super.key});

  @override
  State<MappingScreen> createState() => _MappingScreenState();
}

class _MappingScreenState extends State<MappingScreen> {
  final List<String> _availableGestures = [
    'open_palm', 'fist', 'two_fingers', 'thumb_up', 'look_left', 'look_right'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).loadMappings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final mappings = provider.mappings;
    final devices = provider.devices;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture Mappings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        itemCount: _availableGestures.length,
        separatorBuilder: (_, __) => Divider(color: Colors.white10),
        itemBuilder: (context, index) {
          final gesture = _availableGestures[index];
          // Find if we have a mapping for this gesture
          final existingMapping = mappings.firstWhere(
            (m) => m.gesture == gesture, 
            orElse: () => Mapping(gesture: gesture, action: 'None'),
          );

          return Container(
             margin: EdgeInsets.symmetric(vertical: 5),
             decoration: BoxDecoration(
               color: const Color(0xFF2A2A35),
               borderRadius: BorderRadius.circular(15),
             ),
             child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent.withOpacity(0.2),
                child: Icon(_getGestureIcon(gesture), color: Colors.blueAccent),
              ),
              title: Text(gesture.replaceAll('_', ' ').toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Text(
                existingMapping.action == 'None' ? 'No action assigned' : existingMapping.action, 
                style: TextStyle(color: Colors.blueGrey)
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () => _showEditDialog(context, gesture, existingMapping, devices, provider),
            ),
          );
        },
      ),
    );
  }

  IconData _getGestureIcon(String gesture) {
    if (gesture.contains('eye') || gesture.contains('look')) return Icons.visibility;
    return Icons.back_hand; // Generic hand icon
  }

  void _showEditDialog(BuildContext context, String gesture, Mapping currentMapping, List<Device> devices, HomeProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Map Action for "${gesture.toUpperCase()}"', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 20),
              
              Expanded(
                child: ListView(
                  children: [
                    // Option to clear
                    ListTile(
                      leading: Icon(Icons.block, color: Colors.redAccent),
                      title: Text('No Action', style: TextStyle(color: Colors.white)),
                      onTap: () {
                        provider.saveMapping(Mapping(gesture: gesture, action: 'None', deviceId: ''));
                        Navigator.pop(context);
                      },
                    ),
                    Divider(color: Colors.white10),
                    
                    // Generate options for each device
                    ...devices.expand((device) {
                      return [
                        ListTile(
                          leading: Icon(Icons.power_settings_new, color: Colors.greenAccent),
                          title: Text('Turn ${device.name} ON', style: TextStyle(color: Colors.white)),
                          subtitle: Text(device.roomId.toUpperCase(), style: TextStyle(color: Colors.grey, fontSize: 10)),
                          onTap: () {
                             // Save specific format that backend expects
                            provider.saveMapping(Mapping(
                              gesture: gesture, 
                              action: 'Turn On ${device.name}', // proper internal command
                              deviceId: device.id
                            ));
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.power_off, color: Colors.redAccent),
                          title: Text('Turn ${device.name} OFF', style: TextStyle(color: Colors.white)),
                          subtitle: Text(device.roomId.toUpperCase(), style: TextStyle(color: Colors.grey, fontSize: 10)),
                          onTap: () {
                            provider.saveMapping(Mapping(
                              gesture: gesture, 
                              action: 'Turn Off ${device.name}',
                              deviceId: device.id
                            ));
                            Navigator.pop(context);
                          },
                        ),
                      ];
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
