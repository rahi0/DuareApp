// To parse this JSON data, do
//
//     final shopOwnerProductCategoriesModel = shopOwnerProductCategoriesModelFromJson(jsonString);

import 'dart:convert';

ShopOwnerProductCategoriesModel shopOwnerProductCategoriesModelFromJson(
        String str) =>
    ShopOwnerProductCategoriesModel.fromJson(json.decode(str));

String shopOwnerProductCategoriesModelToJson(
        ShopOwnerProductCategoriesModel data) =>
    json.encode(data.toJson());

class ShopOwnerProductCategoriesModel {
  ShopOwnerProductCategoriesModel({
    this.data,
  });

  List<Datum> data;

  factory ShopOwnerProductCategoriesModel.fromJson(Map<String, dynamic> json) =>
      ShopOwnerProductCategoriesModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.categoryId,
    this.name,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int categoryId;
  String name;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
