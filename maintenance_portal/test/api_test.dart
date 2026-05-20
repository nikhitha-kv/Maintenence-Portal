import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Fetch SAP OData APIs and print responses', () async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://AZKTLDS5CP.kcloud.com:44300/sap/opu/odata/SAP/ZMP_902095_ODATA_SRV',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-requested-with': 'XMLHttpRequest',
          'Authorization': 'Basic ${base64Encode(utf8.encode('K902095:Nikhi@2004'))}',
        },
      ),
    );

    // Bypass SSL certificate check
    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    print('--- Fetching DashSet ---');
    try {
      final response = await dio.get('/DashSet');
      print('DashSet Status Code: ${response.statusCode}');
      final Map<String, dynamic> data = response.data;
      print('DashSet Data keys: ${data.keys}');
      if (data['d'] != null) {
        print('d keys: ${(data['d'] as Map).keys}');
        if (data['d']['results'] != null) {
          final results = data['d']['results'] as List;
          print('results length: ${results.length}');
          if (results.isNotEmpty) {
            print('First result record: ${results[0]}');
          }
        }
      } else {
        print('DashSet raw data: $data');
      }
    } catch (e) {
      print('Error fetching DashSet: $e');
    }

    print('\n--- Fetching NotifSet ---');
    try {
      final response = await dio.get('/NotifSet');
      print('NotifSet Status Code: ${response.statusCode}');
      final Map<String, dynamic> data = response.data;
      if (data['d'] != null && data['d']['results'] != null) {
        final results = data['d']['results'] as List;
        print('results length: ${results.length}');
        if (results.isNotEmpty) {
          print('First result record keys: ${(results[0] as Map).keys}');
          print('First result record: ${results[0]}');
          // Let's print all unique priorities or status-like fields if any exist
          final statuses = results.map((e) => e['Status'] ?? e['StatusText'] ?? e['Astxt'] ?? '').toSet();
          print('Unique Status-like field values in NotifSet: $statuses');
        }
      } else {
        print('NotifSet raw data keys: ${data.keys}');
      }
    } catch (e) {
      print('Error fetching NotifSet: $e');
    }

    print('\n--- Fetching WorkOrdSet ---');
    try {
      final response = await dio.get('/WorkOrdSet');
      print('WorkOrdSet Status Code: ${response.statusCode}');
      final Map<String, dynamic> data = response.data;
      if (data['d'] != null && data['d']['results'] != null) {
        final results = data['d']['results'] as List;
        print('results length: ${results.length}');
        if (results.isNotEmpty) {
          print('First result record keys: ${(results[0] as Map).keys}');
          print('First result record: ${results[0]}');
          final statuses = results.map((e) => e['Status'] ?? e['StatusText'] ?? e['Astxt'] ?? '').toSet();
          print('Unique Status-like field values in WorkOrdSet: $statuses');
        }
      } else {
        print('WorkOrdSet raw data keys: ${data.keys}');
      }
    } catch (e) {
      print('Error fetching WorkOrdSet: $e');
    }
  });
}
