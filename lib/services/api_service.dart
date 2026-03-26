import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/device_model.dart'; // import '../models/device_model.dart';
import '../models/mapping_model.dart'; // import '../models/mapping_model.dart';
import '../models/event_model.dart'; // import '../models/event_model.dart';

abstract class ApiService {
  Future<List<Device>> getDevices();
  Future<void> toggleDevice(String deviceId, bool isOn);
  Future<void> updateDeviceValue(String deviceId, double value);
  Future<List<Mapping>> getMappings();
  Future<void> saveMapping(Mapping mapping);
  Future<Event?> getLastEvent();
}

class MockApiService implements ApiService {
  final List<Device> _devices = [
    Device(id: '1', name: 'Living Room Light', type: DeviceType.light, isOn: true, roomId: 'living_room', value: 80),
    Device(id: '2', name: 'Kitchen Plug', type: DeviceType.plug, isOn: false, roomId: 'kitchen', value: 0),
    Device(id: '3', name: 'Generic Fan', type: DeviceType.fan, isOn: true, roomId: 'bedroom', value: 50),
    Device(id: '4', name: 'Sony TV', type: DeviceType.tv, isOn: false, roomId: 'living_room', value: 20),
  ];

  final List<Mapping> _mappings = [
    Mapping(gesture: 'open_palm', action: 'Turn On Light', deviceId: '1'),
    Mapping(gesture: 'fist', action: 'Turn Off Plug', deviceId: '2'),
    Mapping(gesture: 'two_fingers', action: 'Volume Up', deviceId: '4'),
  ];

  @override
  Future<List<Device>> getDevices() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate latency
    return _devices;
  }

  @override
  Future<void> toggleDevice(String deviceId, bool isOn) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _devices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _devices[index].isOn = isOn;
    }
  }

  @override
  Future<void> updateDeviceValue(String deviceId, double value) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _devices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _devices[index].value = value;
    }
  }

  @override
  Future<List<Mapping>> getMappings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mappings;
  }

  @override
  Future<void> saveMapping(Mapping mapping) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mappings.indexWhere((m) => m.gesture == mapping.gesture);
    if (index != -1) {
      _mappings[index] = mapping;
    } else {
      _mappings.add(mapping);
    }
  }

  int _counter = 0;
  @override
  Future<Event?> getLastEvent() async {
    // Return a random event occasionally
    _counter++;
    if (_counter % 5 == 0) {
      return Event(type: 'gesture', name: 'open_palm', timestamp: DateTime.now());
    }
    return null;
  }
}

class RealApiService implements ApiService {
  final String baseUrl;
  
  RealApiService({required this.baseUrl});

  @override
  Future<List<Device>> getDevices() async {
    final response = await http.get(Uri.parse('$baseUrl/devices'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Device.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  @override
  Future<void> toggleDevice(String deviceId, bool isOn) async {
    final response = await http.post(
      Uri.parse('$baseUrl/device/$deviceId/action'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'command': isOn ? 'ON' : 'OFF'}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle device');
    }
  }

  @override
  Future<void> updateDeviceValue(String deviceId, double value) async {
     final response = await http.post(
      Uri.parse('$baseUrl/device/$deviceId/value'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'value': value}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update device value');
    }
  }

  @override
  Future<List<Mapping>> getMappings() async {
    final response = await http.get(Uri.parse('$baseUrl/mappings'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((e) => Mapping.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load mappings');
    }
  }

  @override
  Future<void> saveMapping(Mapping mapping) async {
    final response = await http.post(
      Uri.parse('$baseUrl/mapping'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mapping.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save mapping');
    }
  }

  @override
  Future<Event?> getLastEvent() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/event/last'));
      if (response.statusCode == 200) {
        return Event.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      // safe fail
    }
    return null;
  }
}
