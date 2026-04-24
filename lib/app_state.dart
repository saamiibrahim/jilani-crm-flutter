import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AppState extends ChangeNotifier {
  ApiService? _apiService;
  List<Lead> leads = [];
  bool isLoading = false;
  String? error;

  bool isReturningFromCall = false;
  String? activeLeadId;

  Future<void> initialize(String baseUrl, String apiKey) async {
    _apiService = ApiService(baseUrl: baseUrl, apiKey: apiKey);
    
    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', baseUrl);
    await prefs.setString('apiKey', apiKey);

    await fetchLeads();
  }

  Future<void> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = prefs.getString('baseUrl');
    final apiKey = prefs.getString('apiKey');

    if (baseUrl != null && baseUrl.isNotEmpty && apiKey != null && apiKey.isNotEmpty) {
      _apiService = ApiService(baseUrl: baseUrl, apiKey: apiKey);
      await fetchLeads();
    }
  }

  bool get isLoggedIn => _apiService != null;
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('baseUrl');
    await prefs.remove('apiKey');
    _apiService = null;
    leads = [];
    notifyListeners();
  }

  Future<void> fetchLeads() async {
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
