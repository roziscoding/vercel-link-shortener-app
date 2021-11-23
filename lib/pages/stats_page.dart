import 'package:flutter/material.dart';
import 'package:vercel_shortener_admin/api.dart';
import 'package:vercel_shortener_admin/domain/config.dart';
import 'package:vercel_shortener_admin/domain/link.dart';
import 'package:vercel_shortener_admin/domain/stats.dart';

Text getCountryText(Country country) {
  return Text(country.id != null ? "${country.id}: ${country.count}" : "-");
}

class StatsWidget extends StatelessWidget {
  final Stats stats;

  const StatsWidget({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Countries", style: theme.textTheme.headline5),
            ...stats.countries.map(getCountryText).toList(),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text("Days", style: theme.textTheme.headline5),
            ),
            ...stats.days.map(getCountryText).toList(),
          ],
        ),
      ],
    );
  }
}

class StatsPage extends StatefulWidget {
  final Link link;
  final Config config;

  const StatsPage({
    Key? key,
    required this.link,
    required this.config,
  }) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<Stats> futureStats;

  @override
  void initState() {
    super.initState();
    futureStats = fetchStats(widget.link.shortcode, config: widget.config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats - ${widget.link.shortcode}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<Stats>(
            future: futureStats,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return StatsWidget(stats: snapshot.data!);
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"));
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
