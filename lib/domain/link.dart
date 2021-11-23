import 'dart:convert';

List<Link> linkFromJson(String str) =>
    List<Link>.from(json.decode(str).map((x) => Link.fromJson(x)));

String linkToJson(List<Link> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Link {
  Link({
    required this.id,
    required this.shortcode,
    required this.longUrl,
  });

  final String id;
  final String shortcode;
  final String longUrl;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        id: json["_id"],
        shortcode: json["shortcode"],
        longUrl: json["longUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "shortcode": shortcode,
        "longUrl": longUrl,
      };
}
