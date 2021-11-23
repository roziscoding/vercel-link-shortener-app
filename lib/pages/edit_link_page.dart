import 'package:flutter/material.dart';
import 'package:vercel_shortener_admin/domain/link.dart';

class EditLinkPage extends StatelessWidget {
  final Link link;
  const EditLinkPage({
    Key? key,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${link.shortcode}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              initialValue: link.shortcode,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Shortcode',
              ),
            ),
            TextFormField(
              initialValue: link.longUrl,
              keyboardType: TextInputType.url,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'URL',
              ),
            ),
            Container(
              child: TextButton(
                child: const Text('SAVE'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(top: 10),
            )
          ],
        ),
      ),
    );
  }
}
