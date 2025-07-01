import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl untuk format harga
import '../app/routes/app_pages.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';

class KeranjangPage extends GetView<CartController> {
  KeranjangPage({Key? key}) : super(key: key);

  // Formatter untuk harga
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Saya'),
        backgroundColor: const Color(0xFF6D4C41),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.brown));
        }
        if (controller.cartItems.isEmpty) {
          return const Center(
              child: Text('Keranjang masih kosong.',
                  style: TextStyle(fontSize: 18)));
        }
        return Column(
          children: [
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
        );
      }),
    );
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
              const Text('Total Harga', style: TextStyle(color: Colors.grey)),
              Obx(() => Text(
                    currencyFormatter.format(controller.totalPrice.value),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )),
            ],
          ),
          ElevatedButton(
            onPressed: controller.cartItems.isEmpty ||
                    controller.isLoading.value
                ? null // Tombol nonaktif
                : () => Get.toNamed(Routes.CHECKOUT), // Navigasi ke checkout
            // ... (style tombol)
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Checkout',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

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
      ),
    );
  }
}
