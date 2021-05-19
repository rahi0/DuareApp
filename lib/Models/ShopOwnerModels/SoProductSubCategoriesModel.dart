// To parse this JSON data, do
//
//     final soProductSubCategoriesModel = soProductSubCategoriesModelFromJson(jsonString);

import 'dart:convert';

SoProductSubCategoriesModel soProductSubCategoriesModelFromJson(String str) => SoProductSubCategoriesModel.fromJson(json.decode(str));

String soProductSubCategoriesModelToJson(SoProductSubCategoriesModel data) => json.encode(data.toJson());

class SoProductSubCategoriesModel {
    SoProductSubCategoriesModel({
        this.data,
    });

    List<Datum> data;

    factory SoProductSubCategoriesModel.fromJson(Map<String, dynamic> json) => SoProductSubCategoriesModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.productCategoryId,
        this.name,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.categoryId,
    });

    int id;
    int productCategoryId;
    String name;
    String image;
    DateTime createdAt;
    DateTime updatedAt;
    int categoryId;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        productCategoryId: json["product_category_id"] == null ? null : json["product_category_id"],
        name: json["name"],
        image: json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        categoryId: json["category_id"] == null ? null : json["category_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_category_id": productCategoryId == null ? null : productCategoryId,
        "name": name,
        "image": image,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "category_id": categoryId == null ? null : categoryId,
    };
}
