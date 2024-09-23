import 'dart:convert';
import 'package:bumblebee/models/Admin+Teacher/class_model.dart';
import 'package:bumblebee/models/Admin/school_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClassRepository {
  final String baseUrl = 'https://bumblebeeflutterdeploy-production.up.railway.app/api/class';

Future<List<Class>> fetchClasses() async {
  final response = await http.get(Uri.parse('$baseUrl/list'));
  
  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Class.fromJson(json)).toList();
  } else {
    print('Failed to load classes: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to load classes');
  }
}


  Future<void> createClass(Class newClass, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: json.encode({
        'className': newClass.className,
        'grade': newClass.grade,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var jsonResponse = json.decode(response.body);

    print('Parsed JSON response: $jsonResponse');

        Future<Class> createClass(Class newClass, String token) async {
  final response = await http.post(
    Uri.parse('$baseUrl/create'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', 
    },
    body: json.encode({
      'className': newClass.className,
      'grade': newClass.grade,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var jsonResponse = json.decode(response.body);

  print('Parsed JSON response: $jsonResponse');

  if (response.statusCode == 200) {
    bool success = jsonResponse['con'] ?? false;
    if (success) {
      String token = jsonResponse['result']['token'];
      print('Bearer Token: $token');

      Future<void> saveToken(String token) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);
      }

      // Handle successful registration
      var result = jsonResponse['result'];
      if (result != null && result['className'] != null) {
        // Return the created Class instance
        return Class.fromJson(result['className']);
      } else {
        throw Exception('Failed to register: No class data found in response');
      }
    } else {
      // Handle failure scenario based on `msg`
      String message = jsonResponse['msg'] ?? 'Unknown error occurred';
      throw Exception('Failed to register: $message');
    }
  } else {
    throw Exception('Failed to register: HTTP status ${response.statusCode}');
  }
}

  Future<void> editClass(Class updatedClass) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit/${updatedClass.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedClass.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit class');
    }
  }

  Future<void> deleteClass(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete class');
    }
  }
}

  editClass(Class updatedClass) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit/${updatedClass.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedClass.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit class');
    }
  }


  deleteClass(String classId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$classId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete class');
    }
  }
}