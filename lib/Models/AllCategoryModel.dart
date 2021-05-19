// // To parse this JSON data, do
// //
// //     final allCategoryModel = allCategoryModelFromJson(jsonString);

// import 'dart:convert';

// AllCategoryModel allCategoryModelFromJson(String str) =>
//     AllCategoryModel.fromJson(json.decode(str));

// String allCategoryModelToJson(AllCategoryModel data) =>
//     json.encode(data.toJson());

// class AllCategoryModel {
//   AllCategoryModel({
//     this.data,
//   });

//   List<Datum> data;

//   factory AllCategoryModel.fromJson(Map<String, dynamic> json) =>
//       AllCategoryModel(
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class Datum {
//   Datum({
//     this.id,
//     this.name,
//     this.image,
//     this.createdAt,
//     this.updatedAt,
//   });

//   int id;
//   String name;
//   String image;
//   DateTime createdAt;
//   DateTime updatedAt;

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         name: json["name"],
//         image: json["image"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }
