import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Config {
  String apiUrl;
  String frontendPrefix;
  String apiToken;

  Config({
    required this.apiUrl,
    required this.frontendPrefix,
    required this.apiToken,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      apiUrl: json['apiUrl'],
      frontendPrefix: json['frontendPrefix'],
      apiToken: json['apiToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiUrl': apiUrl,
      'frontendPrefix': frontendPrefix,
      'apiToken': apiToken,
    };
  }

  Future<void> save() async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'apiUrl', value: apiUrl);
    await storage.write(key: 'frontendPrefix', value: frontendPrefix);
    await storage.write(key: 'apiToken', value: apiToken);
  }
}

Future<Config> loadConfig() async {
  const store = FlutterSecureStorage();
  final apiUrl = await store.read(key: 'apiUrl') ?? '';
  final frontendPrefix = await store.read(key: 'frontendPrefix') ?? '';
  final apiToken = await store.read(key: 'apiToken') ?? '';

  return Config(
    apiUrl: apiUrl,
    frontendPrefix: frontendPrefix,
    apiToken: apiToken,
  );
}
