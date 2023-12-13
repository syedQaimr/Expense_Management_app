import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  String? _jwtToken;

  void setJwtToken(String token) {
    _jwtToken = token;
  }

  String? getUserIdFromToken() {
    if (_jwtToken != null) {
      final parts = _jwtToken!.split('.');
      if (parts.length == 3) {
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );

        if (payload.containsKey('userId')) {
          return payload['userId'];
        }
      }
    }
    return null;
  }

  String? getUserEmailFromToken() {
    if (_jwtToken != null) {
      final parts = _jwtToken!.split('.');
      if (parts.length == 3) {
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );

        if (payload.containsKey('userId')) {
          // Assuming the email is associated with the user ID
          String userId = payload['userId'];
          // Extract email from the userId (replace with your logic)
          String email = extractEmailFromUserId(userId);
          return email;
        }
      }
    }
    return null;
  }

  String extractEmailFromUserId(String userId) {
    // Replace this with your logic to extract email from the userId
    // For example, if userId is "muhammad@gmail.com", extract "muhammad"
    List<String> parts = userId.split('@');
    if (parts.length == 2) {
      return parts[0];
    }
    return userId; // Fallback to the full userId if extraction fails
  }

  Future<String?> getUserEmail(String? userId) async {
    final response = await http.get(
      Uri.parse("http://localhost:8080/get-user-email/$userId"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true) {
        return data['email'];
      } else {
        // Handle user not found or other errors
        return null;
      }
    } else {
      // Handle server error
      print("Error fetching user email: ${response.statusCode}");
      return null;
    }
  }

  String extractUsernameFromEmail(String? email) {
    if (email != null && email.isNotEmpty) {
      List<String> parts = email.split('@');
      if (parts.length == 2) {
        return parts[0];
      }
    }
    return email ?? ''; // Fallback to an empty string if extraction fails
  }
}
