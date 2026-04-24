import 'dart:convert';
import 'package:http/http.dart' as http;

class Lead {
  final String id;
  final String name;
  final String phoneNumber;
  final String status;
  final String company;

  Lead({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.status,
    required this.company,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Name',
      phoneNumber: json['phoneNumber'] ?? '',
      status: json['status'] ?? '',
      company: json['company'] ?? 'Unknown Property',
    );
  }
}

class ApiService {
  final String baseUrl;
  final String apiKey;

  ApiService({required this.baseUrl, required this.apiKey});

  Map<String, String> get _headers => {
        'X-Api-Key': apiKey,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<Lead>> fetchNewLeads() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/Lead?where[0][type]=equals&where[0][attribute]=status&where[0][value]=New'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> leadsJson = jsonResponse['list'] ?? [];
      return leadsJson.map((json) => Lead.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load leads: ${response.statusCode}');
    }
  }

  Future<void> updateLead(String id, String status, String description) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/v1/Lead/$id'),
      headers: _headers,
      body: json.encode({
        'status': status,
        'description': description,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update lead: ${response.statusCode}');
    }
  }
}
