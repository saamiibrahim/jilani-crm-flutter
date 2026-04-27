import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AppState extends ChangeNotifier {
  ApiService? _apiService;
  List<Lead> leads = [];
  bool isLoading = false;
  String? error;
  bool useDummyData = false;

  bool isReturningFromCall = false;
  String? activeLeadId;

  // Dummy leads for testing UI without a backend
  static final List<Lead> _dummyLeads = [
    Lead(
      id: '1',
      name: 'Ahmed Al Maktoum',
      phoneNumber: '+971501234567',
      status: 'New',
      company: 'Sky Hills Tower',
    ),
    Lead(
      id: '2',
      name: 'Sarah Johnson',
      phoneNumber: '+971509876543',
      status: 'New',
      company: 'Azizi Venice',
    ),
    Lead(
      id: '3',
      name: 'Rashid bin Saeed',
      phoneNumber: '+971505551234',
      status: 'New',
      company: 'Sobha Hartland',
    ),
    Lead(
      id: '4',
      name: 'Maria Garcia',
      phoneNumber: '+971507779999',
      status: 'New',
      company: 'Damac Lagoons',
    ),
    Lead(
      id: '5',
      name: 'Omar Farooq',
      phoneNumber: '+971503334444',
      status: 'New',
      company: 'Emaar Beachfront',
    ),
  ];

  Future<void> initialize(String baseUrl, String apiKey) async {
    // If credentials look like dummy/test, use dummy data
    // if (baseUrl.isEmpty || apiKey.isEmpty || baseUrl == 'test' || apiKey == 'test') {
    useDummyData = true;
    _apiService = null; // mark as "logged in" via dummy flag
    leads = List.from(_dummyLeads);
    notifyListeners();
    return;
    // }

    _apiService = ApiService(baseUrl: baseUrl, apiKey: apiKey);

    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', baseUrl);
    await prefs.setString('apiKey', apiKey);

    await fetchLeads();
  }

  Future<void> loadSavedCredentials() async {
    // Use dummy data for testing
    useDummyData = true;
    leads = List.from(_dummyLeads);
    notifyListeners();
  }

  bool get isLoggedIn => _apiService != null || useDummyData;

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('baseUrl');
    await prefs.remove('apiKey');
    _apiService = null;
    useDummyData = false;
    leads = [];
    notifyListeners();
  }

  Future<void> fetchLeads() async {
    if (useDummyData) {
      leads = List.from(_dummyLeads);
      notifyListeners();
      return;
    }
    if (_apiService == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      leads = await _apiService!.fetchNewLeads();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeActiveLead() {
    if (activeLeadId != null) {
      leads.removeWhere((lead) => lead.id == activeLeadId);
      activeLeadId = null;
      notifyListeners();
    }
  }

  Future<void> updateLeadStatus(String status, String notes) async {
    if (useDummyData) {
      // In dummy mode, just remove the lead
      removeActiveLead();
      return;
    }
    if (_apiService == null || activeLeadId == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _apiService!.updateLead(activeLeadId!, status, notes);
      removeActiveLead();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
