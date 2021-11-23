import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vercel_shortener_admin/domain/config.dart';
import 'package:vercel_shortener_admin/pages/links_page.dart';

class FirstUsagePage extends StatefulWidget {
  final String? token;
  final Config? config;

  const FirstUsagePage({
    Key? key,
    this.token,
    this.config,
  }) : super(key: key);

  @override
  State<FirstUsagePage> createState() => _FirstUsagePageState();
}

class _FirstUsagePageState extends State<FirstUsagePage> {
  String frontendPrefix = '';
  String apiUrl = '';

  @override
  void initState() {
    super.initState();
    if (widget.config != null) {
      frontendPrefix = widget.config!.frontendPrefix;
      apiUrl = widget.config!.apiUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initial configuration'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                initialValue: apiUrl,
                autocorrect: false,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Main API Domain',
                  hintText: 'mydomain.com',
                ),
                onChanged: (value) => setState(() => apiUrl = value),
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please enter a valid domain'
                      : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                initialValue: frontendPrefix,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Frontend prefix',
                  hintText: 'admin',
                ),
                onChanged: (value) => setState(() => frontendPrefix = value),
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'Please enter a valid prefix'
                      : null;
                },
              ),
            ),
            Visibility(
              visible: widget.token != null,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  initialValue: widget.token,
                  autocorrect: false,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Authentication token',
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    child: Text(
                      widget.token == null || widget.token!.isEmpty
                          ? 'Open login page'
                          : 'Save',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      widget.config?.apiUrl = apiUrl;
                      widget.config?.frontendPrefix = frontendPrefix;
                      await widget.config?.save();

                      if (widget.token == null) {
                        String loginUrl =
                            "https://$frontendPrefix.$apiUrl?deeplink=true";

                        if (await canLaunch(loginUrl)) {
                          await launch(loginUrl);
                        }

                        return;
                      }

                      widget.config?.apiToken = widget.token!;
                      await widget.config?.save();

                      Config config = Config(
                        apiUrl: apiUrl,
                        frontendPrefix: frontendPrefix,
                        apiToken: widget.token!,
                      );

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => LinksPage(config: config),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
