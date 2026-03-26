import 'package:flutter/foundation.dart';
import '../models/device_model.dart';
import '../models/mapping_model.dart';
import '../models/event_model.dart';
import '../services/api_service.dart';

class HomeProvider with ChangeNotifier {
  ApiService _apiService = MockApiService();
  
  List<Device> _devices = [];
  List<Mapping> _mappings = [];
  Event? _lastEvent;
  bool _isLoading = false;

  List<Device> get devices => _devices;
  List<Mapping> get mappings => _mappings;
  Event? get lastEvent => _lastEvent;
  bool get isLoading => _isLoading;

  // Rooms logic
  List<String> get rooms => _devices.map((d) => d.roomId).toSet().toList();
  
  List<Device> getDevicesByRoom(String roomId) {
    return _devices.where((d) => d.roomId == roomId).toList();
  }

  Future<void> loadDevices() async {
    _isLoading = true;
    notifyListeners();
    try {
      _devices = await _apiService.getDevices();
    } catch (e) {
      print('Error loading devices: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleDevice(String id) async {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index != -1) {
      final device = _devices[index];
      final newValue = !device.isOn;
      
      // Optimistic update
      device.isOn = newValue;
      notifyListeners();
      
      try {
        await _apiService.toggleDevice(id, newValue);
      } catch (e) {
        // Revert
        device.isOn = !newValue;
        notifyListeners();
        print('Error toggling device: $e');
      }
    }
  }

  Future<void> updateDeviceValue(String id, double value) async {
    final index = _devices.indexWhere((d) => d.id == id);
    if (index != -1) {
      _devices[index].value = value;
      notifyListeners();
      // Debouncing could be added here to avoid too many API calls
      try {
        await _apiService.updateDeviceValue(id, value);
      } catch (e) {
        print('Error updating value: $e');
      }
    }
  }

  Future<void> loadMappings() async {
    try {
      _mappings = await _apiService.getMappings();
      notifyListeners();
    } catch (e) {
      print('Error loading mappings: $e');
    }
  }

  Future<void> saveMapping(Mapping mapping) async {
    try {
      await _apiService.saveMapping(mapping);
      await loadMappings(); // Reload to confirm
    } catch (e) {
      print('Error saving mapping: $e');
    }
  }

  void startEventPolling() {
    // Simple polling for demo
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      _lastEvent = await _apiService.getLastEvent();
      if (_lastEvent != null) {
        notifyListeners();
      }
      return true; 
    });
  }
}
