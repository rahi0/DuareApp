// To parse this JSON data, do
//
//     final allBannerModel = allBannerModelFromJson(jsonString);

import 'dart:convert';

List<AllBannerModel> allBannerModelFromJson(String str) =>
    List<AllBannerModel>.from(
        json.decode(str).map((x) => AllBannerModel.fromJson(x)));

String allBannerModelToJson(List<AllBannerModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllBannerModel {
  AllBannerModel({
    this.id,
    this.categoryId,
    this.title,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int categoryId;
  String title;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  factory AllBannerModel.fromJson(Map<String, dynamic> json) => AllBannerModel(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        image: json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "image": image,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
