import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vercel_shortener_admin/consts.dart';
import 'package:vercel_shortener_admin/domain/config.dart';
import 'package:vercel_shortener_admin/domain/link.dart';
import 'package:vercel_shortener_admin/pages/edit_link_page.dart';
import 'package:vercel_shortener_admin/pages/stats_page.dart';

void copyToClipboard(BuildContext context, String text) {
  Clipboard.setData(ClipboardData(text: text)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$text" copied to clipboard'),
        duration: const Duration(seconds: 1),
      ),
    );
  });
}

void navigate(BuildContext context, Widget destination) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => destination),
  );
}

class LinkCard extends StatelessWidget {
  final Config config;

  const LinkCard({Key? key, required this.link, required this.config})
      : super(key: key);

  final Link link;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: ValueKey(link.id),
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              icon: Icons.copy,
              label: 'Short URL',
              onPressed: (context) =>
                  copyToClipboard(context, "https://$apiURL/${link.shortcode}"),
              backgroundColor: Colors.green,
            ),
            SlidableAction(
              icon: Icons.copy,
              label: 'Long URL',
              onPressed: (context) => copyToClipboard(context, link.longUrl),
              backgroundColor: Colors.greenAccent,
            ),
          ],
        ),
        endActionPane: ActionPane(motion: const BehindMotion(), children: [
          SlidableAction(
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (context) {
              navigate(context, EditLinkPage(link: link));
            },
            backgroundColor: Colors.blue,
          ),
          SlidableAction(
            icon: Icons.delete,
            label: 'Delete',
            onPressed: (context) {},
            backgroundColor: Colors.red,
          )
        ]),
        child: ListTile(
          title: Text(link.shortcode),
          subtitle: Text(link.longUrl),
          onTap: () {
            navigate(context, StatsPage(link: link, config: config));
          },
        ));
  }
}
