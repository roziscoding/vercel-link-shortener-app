import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:vercel_shortener_admin/domain/config.dart';
import 'package:vercel_shortener_admin/pages/first_usage_page.dart';
import 'package:vercel_shortener_admin/pages/links_page.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

void handleLink(BuildContext context, {Uri? link, required Config config}) {
  if (link == null) return;

  String? token = link.queryParameters['token'];

  if (token != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FirstUsagePage(
          token: token,
          config: config,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade600,
          secondary: Colors.grey.shade600,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Config> authenticatedFuture;
  late StreamSubscription _sub;

  Future<void> initLinks() async {
    final config = await loadConfig();
    final initialLink = await getInitialUri();

    handleLink(context, link: initialLink, config: config);

    _sub = uriLinkStream.listen((link) {
      handleLink(context, link: link, config: config);
    });
  }

  @override
  void initState() {
    super.initState();
    authenticatedFuture = loadConfig();
    initLinks();
  }

  @override
  void dispose() {
    super.dispose();
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Config>(
      future: authenticatedFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.apiToken.isNotEmpty) {
            return LinksPage(config: snapshot.data!);
          } else {
            return FirstUsagePage(config: snapshot.data!);
          }
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Vercel Shortener Admin'),
            ),
            body: Center(
              child: Text(
                '${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Vercel Shortener Admin'),
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: CircularProgressIndicator(),
                  ),
                  Text('Loading configuration...')
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
