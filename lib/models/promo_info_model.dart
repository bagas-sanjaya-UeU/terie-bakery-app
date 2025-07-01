class PromoInfoModel {
  final int freeShippingThreshold;
  final bool isEligible;
  final int amountNeededForFreeShipping;

  PromoInfoModel({
    required this.freeShippingThreshold,
    required this.isEligible,
    required this.amountNeededForFreeShipping,
  });

  factory PromoInfoModel.fromJson(Map<String, dynamic> json) => PromoInfoModel(
        freeShippingThreshold: json["free_shipping_threshold"],
        isEligible: json["is_eligible"],
        amountNeededForFreeShipping: json["amount_needed_for_free_shipping"],
      );
}
