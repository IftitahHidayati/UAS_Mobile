import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/category.dart';
import 'globals.dart';

class AuthServices {
  final String token = '';

  static Future<http.Response> register(
    String name,
    String email,
    String password,
    String device_name,
  ) async {
    Map data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'device_name': device_name,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseUrl + 'auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }

  static Future<http.Response> login(
    String email,
    String password,
    String device_name,
  ) async {
    Map data = {
      "email": email,
      "password": password,
      "device_name": device_name,
    };

    var body = json.encode(data);
    var url = Uri.parse(baseUrl + 'auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print('token');
    print(response.body);
    var datas = json.decode(response.body);

    _save('token', datas['token']);
    // save('name', datas['name']);
    return response;
  }

  static Future<http.Response> logout(String token) async {
    var url = Uri.parse(baseUrl + 'auth/logout');
    final body = {};
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' '$token',
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print(response.body);
    return response;
  }

  Future<http.Response> requestAddCategory(String name) async {
    var url = Uri.parse(baseUrl + 'categories');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*",
        "Authorization": "Bearer $token",
      },
      body: {
        "name": name,
      },
    );
    return response;
  }

  Future<http.Response> editCategory(Category category, String name) async {
    final url = Uri.parse(baseUrl + 'categories/${category.id}');
    SharedPreferences pref = await SharedPreferences.getInstance();
    const key = 'token';
    final value = pref.get(key);
    final token = value;
    final body = {
      'name': name,
    };
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + '$token',
    };

    final response = await http.put(url, body: body, headers: headers);

    print(response.body);
    print(response.statusCode);
    return response;
  }

  static _save(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    //const key = 'token';
    //final value = token;
    prefs.setString(key, data);
  }

  read() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }

  getCategories() async {
    final url = Uri.parse(baseUrl + 'categories');
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final token = prefs.getString(key);
    final headers = {
      'Authorization': 'Bearer ' + '$token',
      'Accept': 'application/json',
    };
    final response = await http.get(url, headers: headers);
    print('kategori');
    print(response.body);
    return response;
  }
}
