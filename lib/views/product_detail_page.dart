import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart'; // Tambahkan package flutter_html untuk menampilkan deskripsi
import '../controllers/product_detail_controller.dart';

// Gunakan GetView untuk akses controller yang lebih mudah
class ProductDetailPage extends GetView<ProductDetailController> {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        elevation: 0,
        title: const Text('Detail Produk',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      // Gunakan Obx untuk bagian yang perlu update berdasarkan state
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.brown));
        }
        if (controller.product.value == null) {
          return const Center(child: Text("Produk tidak ditemukan."));
        }

        final product = controller.product.value!;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  product.imageUrl,
                  height: 230,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.error, size: 50),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723))),
                    const SizedBox(height: 8),
                    Text("Rp ${product.price.split('.')[0]}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723))),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        // Gunakan flutter_html untuk merender deskripsi
                        child: Html(data: product.description),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: controller.decrementQuantity,
                            icon: const Icon(Icons.remove_circle,
                                color: Color(0xFF3E2723), size: 30)),
                        Obx(() => Text(controller.quantity.value.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3E2723)))),
                        IconButton(
                            onPressed: controller.incrementQuantity,
                            icon: const Icon(Icons.add_circle,
                                color: Color(0xFF3E2723), size: 30)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Obx(() => ElevatedButton.icon(
                            onPressed: controller.isAddingToCart.value
                                ? null
                                : controller.addToCart,
                            icon: controller.isAddingToCart.value
                                ? Container(
                                    width: 24,
                                    height: 24,
                                    padding: const EdgeInsets.all(2.0),
                                    child: const CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 3))
                                : const Icon(Icons.shopping_cart),
                            label: const Text('Tambahkan ke Keranjang'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF3E2723),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                          )),
                    ),
                    // Anda bisa menambahkan tombol Beli Sekarang di sini jika perlu
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
