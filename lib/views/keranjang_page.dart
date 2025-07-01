import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../app/routes/app_pages.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';

class KeranjangPage extends GetView<CartController> {
  KeranjangPage({Key? key}) : super(key: key);

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Saya',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF6D4C41),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.brown));
        }
        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('Keranjang masih kosong.',
                    style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchCartItems,
          child: Column(
            children: [
              _buildPromoInfo(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    return CartItemCard(item: item);
                  },
                ),
              ),
              _buildSummary(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPromoInfo() {
    return Obx(() {
      final promo = controller.promoInfo.value;

      // 1. Pengecekan awal, jika promo null, jangan tampilkan apa-apa.
      if (promo == null) {
        return const SizedBox.shrink();
      }

      if (promo.isEligible) {
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Selamat! Anda mendapatkan gratis ongkir.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ],
          ),
        );
      }

      // --- PERBAIKAN DI SINI ---
      // 2. Tambahkan pengecekan untuk menghindari pembagian dengan nol.
      // Jika syarat gratis ongkir adalah 0 atau kurang, jangan tampilkan widget promo.
      if (promo.freeShippingThreshold <= 0) {
        return const SizedBox.shrink();
      }

      final progress = controller.subtotal.value / promo.freeShippingThreshold;

      return Card(
        margin: const EdgeInsets.all(8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Belanja ${currencyFormatter.format(promo.amountNeededForFreeShipping)} lagi untuk GRATIS ONGKIR!",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.amber,
                  minHeight: 10,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Subtotal', style: TextStyle(color: Colors.grey)),
              Obx(() => Text(
                    currencyFormatter.format(controller.subtotal.value),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )),
            ],
          ),
          Obx(() => ElevatedButton(
                onPressed:
                    controller.cartItems.isEmpty || controller.isLoading.value
                        ? null
                        : () => Get.toNamed(Routes.CHECKOUT),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Checkout',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              )),
        ],
      ),
    );
  }
}

// Widget CartItemCard tidak perlu diubah
class CartItemCard extends GetView<CartController> {
  final CartItemModel item;
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  CartItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                      currencyFormatter
                          .format(double.parse(item.product.price)),
                      style: TextStyle(
                          color: Colors.brown.shade700,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => controller.deleteItem(item),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () =>
                            controller.updateQuantity(item, item.quantity - 1),
                        icon: const Icon(Icons.remove_circle_outline)),
                    Text(item.quantity.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: () =>
                            controller.updateQuantity(item, item.quantity + 1),
                        icon: const Icon(Icons.add_circle_outline)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
