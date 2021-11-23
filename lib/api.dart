import 'dart:async';
import 'dart:convert';

import 'package:vercel_shortener_admin/consts.dart';
import 'package:vercel_shortener_admin/domain/config.dart';
import 'package:vercel_shortener_admin/domain/link.dart';
import 'package:vercel_shortener_admin/domain/stats.dart';
import 'package:http/http.dart' as http;

Future<Stats> fetchStats(String shortcode, {required Config config}) async {
  final response = await http.get(
    Uri.https(apiURL, 'api/stats', {'shortcode': shortcode}),
    headers: {'Authorization': "Bearer ${config.apiToken}"},
  );

  if (response.statusCode == 200) {
    return Stats.fromJson(jsonDecode(response.body));
  } else {
    throw Exception(response.body);
  }
}

Future<List<Link>> fetchLinks({required Config config}) async {
  final response = await http.get(
    Uri.https(apiURL, 'api/links'),
    headers: {'Authorization': "Bearer ${config.apiToken}"},
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((e) => Link.fromJson(e))
        .toList();
  } else if (response.statusCode == 401) {
    config.apiToken = '';
    await config.save();
    throw Exception('Invalid API token. Restart app to log in again');
  } else {
    throw Exception(response.body);
  }
}
