import 'package:flutter/material.dart';
import 'package:vercel_shortener_admin/api.dart';
import 'package:vercel_shortener_admin/components/link_card.dart';
import 'package:vercel_shortener_admin/domain/config.dart';
import 'package:vercel_shortener_admin/domain/link.dart';

class LinkList extends StatelessWidget {
  final List<Link> links;
  final Config config;

  const LinkList({
    Key? key,
    required this.links,
    required this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: links.length,
        itemBuilder: (context, index) {
          final link = links[index];
          return LinkCard(link: link, config: config);
        });
  }
}

class LinksPage extends StatefulWidget {
  final Config config;
  const LinksPage({
    Key? key,
    required this.config,
  }) : super(key: key);

  @override
  State<LinksPage> createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {
  late Future<List<Link>> futureLinks;

  @override
  void initState() {
    super.initState();
    futureLinks = fetchLinks(config: widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vercel Link Shortener Admin'),
      ),
      body: FutureBuilder<List<Link>>(
        future: futureLinks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LinkList(links: snapshot.data!, config: widget.config);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
