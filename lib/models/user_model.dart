import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String role;
  final DateTime createdAt;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.role,
    required this.createdAt,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? finalImageUrl;
    if (json["image_url"] != null && json["image_url"].isNotEmpty) {
      finalImageUrl = json["image_url"];
    } else if (json["image"] != null && json["image"].isNotEmpty) {
      finalImageUrl = "https://terie-bakery.biz.id/storage/${json['image']}";
    }

    return UserModel(
      // Berikan nilai default 0 jika id null
      id: json["id"] ?? 0,

      // Berikan nilai default '' (string kosong) jika data dari API null
      name: json["name"] ?? '',
      email: json["email"] ?? '',

      // Untuk field nullable (String?), tidak perlu diubah
      phone: json["phone"],
      address: json["address"],

      // Berikan nilai default 'user' jika role null
      role: json["role"] ?? 'user',

      // Cek null sebelum parsing tanggal untuk menghindari error
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(), // Berikan waktu saat ini sebagai default jika null

      imageUrl: finalImageUrl,
    );
  }
}
