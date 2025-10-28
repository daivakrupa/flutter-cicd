import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkManager<T> {
  final String baseUrl;
  NetworkManager(this.baseUrl);

  Future<T?> get(String endpoint, T Function(dynamic) fromJson) async {
    var url = Uri.parse('$baseUrl$endpoint');
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint("got responce body ${response.body}");
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      debugPrint('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<T?> getListOfObjects(
    String endpoint,
    T Function(List<dynamic>) fromJson,
  ) async {
    var url = Uri.parse('$baseUrl$endpoint');
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<T?> post(
    String endpoint,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson,
    Authentication? auth,
    Function(int) setStatusCode,
  ) async {
    var basicAuth = auth != null
        ? 'Basic ${base64Encode(utf8.encode(''))}'
        : '';
    var url = Uri.parse('$baseUrl$endpoint');
    var headers = auth != null
        ? {'Content-Type': 'application/json', 'Authorization': basicAuth}
        : {'Content-Type': 'application/json', 'accept': 'application/json'};
    var jsonBody = jsonEncode(body);
    var response = await http.post(url, body: jsonBody, headers: headers);
    setStatusCode(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      var data = jsonDecode(response.body);
      return fromJson(data);
    }
  }

  Future<T?> put(
    String endpoint,
    Map<String, dynamic> body,
    T Function(dynamic) fromJson,
    Authentication? auth,
  ) async {
    var basicAuth = auth != null
        ? 'Basic ${base64Encode(utf8.encode('rzp_test_4wZO5YRyjtACT2:nvGyVuemI5s643oUVGyzpsex'))}'
        : '';
    var url = Uri.parse('$baseUrl$endpoint');
    var headers = auth != null
        ? {'Content-Type': 'application/json', 'Authorization': basicAuth}
        : {'Content-Type': 'application/json', 'accept': 'application/json'};
    var jsonBody = jsonEncode(body);
    var response = await http.put(url, body: jsonBody, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<T?> postListOfObjects(
    String endpoint,
    Map<String, dynamic> body,
    T Function(List<dynamic>) fromJson,
    Authentication? auth,
  ) async {
    var basicAuth = auth != null
        ? 'Basic ${base64Encode(utf8.encode('rzp_test_4wZO5YRyjtACT2:nvGyVuemI5s643oUVGyzpsex'))}'
        : '';
    var url = Uri.parse('$baseUrl$endpoint');
    var headers = auth != null
        ? {'Content-Type': 'application/json', 'Authorization': basicAuth}
        : {'Content-Type': 'application/json', 'accept': 'application/json'};
    var jsonBody = jsonEncode(body);
    var response = await http.post(url, body: jsonBody, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('i got response from api ${response.body}');
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  Future<T> postProfilePicToserver(
    String imagePath,
    String endpoint,
    String fileName,
    String? bucketName,
    String? filePath,
    T Function(http.StreamedResponse) fromJson,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
    request.fields.addAll({
      'filename': fileName,
    });
    bucketName != null ? request.fields.addAll({'bucket': bucketName}) : null;
    filePath != null ? request.fields.addAll({'path': filePath}) : null;

    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
            debugPrint('i got response from api $response');
      var data = jsonDecode(await response.stream.bytesToString());
      return fromJson(data);

    } else {
      debugPrint('i got response from api $response');
      var data = jsonDecode(await response.stream.bytesToString());
      return fromJson(data);
    }
  }
}

enum Authentication { basicAuth }
