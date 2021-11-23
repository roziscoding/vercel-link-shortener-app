import 'dart:convert';

Stats statsFromJson(String str) => Stats.fromJson(json.decode(str));

String statsToJson(Stats data) => json.encode(data.toJson());

class Stats {
  Stats({
    required this.countries,
    required this.refs,
    required this.days,
  });

  final List<Country> countries;
  final List<Country> refs;
  final List<Country> days;

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      countries:
          List<Country>.from(json["countries"].map((x) => Country.fromJson(x))),
      refs: List<Country>.from(json["refs"].map((x) => Country.fromJson(x))),
      days: List<Country>.from(json["days"].map((x) => Country.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "countries": List<dynamic>.from(countries.map((x) => x.toJson())),
        "refs": List<dynamic>.from(refs.map((x) => x.toJson())),
        "days": List<dynamic>.from(days.map((x) => x.toJson())),
      };
}

class Country {
  Country({
    required this.id,
    required this.count,
  });

  final String? id;
  final int count;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["_id"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "count": count,
      };
}
