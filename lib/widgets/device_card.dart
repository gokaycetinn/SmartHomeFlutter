import 'package:flutter/material.dart';
import '../models/device_model.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: device.isOn ? Colors.blueAccent.withOpacity(0.2) : const Color(0xFF2A2A35),
          borderRadius: BorderRadius.circular(20),
          border: device.isOn ? Border.all(color: Colors.blueAccent) : null,
          boxShadow: [
            if (device.isOn)
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: device.isOn ? Colors.blueAccent : Colors.white10,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(device.type), 
                color: Colors.white,
                size: 24
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  device.isOn ? 'ON' : 'OFF', 
                  style: TextStyle(
                    color: device.isOn ? Colors.blueAccent : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light: return Icons.lightbulb;
      case DeviceType.tv: return Icons.tv;
      case DeviceType.plug: return Icons.power;
      case DeviceType.fan: return Icons.mode_fan_off;
      default: return Icons.devices;
    }
  }
}
