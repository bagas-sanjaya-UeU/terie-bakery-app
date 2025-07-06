// Model untuk satu item banner
class BannerItemModel {
  final int id;
  final String imageUrl;

  BannerItemModel({
    required this.id,
    required this.imageUrl,
  });

  factory BannerItemModel.fromJson(Map<String, dynamic> json) =>
      BannerItemModel(
        id: json["id"],
        imageUrl: json["image_url"],
      );
}

// Model untuk menampung keseluruhan respons banner
class BannersResponseModel {
  final BannerItemModel? storeBanner;
  final BannerItemModel? storeBannerKedua;

  BannersResponseModel({
    this.storeBanner,
    this.storeBannerKedua,
  });

  factory BannersResponseModel.fromJson(Map<String, dynamic> json) =>
      BannersResponseModel(
        storeBanner: json["store_banner"] == null
            ? null
            : BannerItemModel.fromJson(json["store_banner"]),
        storeBannerKedua: json["store_banner_kedua"] == null
            ? null
            : BannerItemModel.fromJson(json["store_banner_kedua"]),
      );
}
