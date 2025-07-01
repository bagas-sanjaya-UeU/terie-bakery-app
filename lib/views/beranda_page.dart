import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../models/product_model.dart';
// import '../app/routes/app_pages.dart'; // Untuk navigasi ke detail nanti

class BerandaPage extends StatelessWidget {
  BerandaPage({Key? key}) : super(key: key);

  // Daftarkan HomeController. GetX akan mengelolanya.
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Selamat Datang!",
            style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.brown),
            onPressed: () {/* TODO: Implement search functionality */},
          ),
        ],
      ),
      // Gunakan Obx untuk membuat UI reaktif terhadap perubahan di controller
      body: Obx(() {
        // 1. Tampilkan loading indicator jika sedang mengambil data
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.brown));
        }
        // 2. Tampilkan pesan jika tidak ada produk
        if (controller.productList.isEmpty) {
          return const Center(
              child: Text("Tidak ada produk yang tersedia saat ini."));
        }
        // 3. Tampilkan GridView jika ada produk
        return RefreshIndicator(
          onRefresh: controller.fetchProducts, // Fungsi pull-to-refresh
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.productList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3, // Membuat kartu lebih tinggi
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final ProductModel product = controller.productList[index];
              return ProductCard(product: product);
            },
          ),
        );
      }),
    );
  }
}

// Widget terpisah untuk kartu produk agar kode lebih rapi dan bisa digunakan kembali
class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product.id);
        print("Tapped on product: ${product.name}");
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  // Tampilkan loading indicator saat gambar dimuat
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ));
                  },
                  // Tampilkan icon error jika gambar gagal dimuat
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 40, color: Colors.grey);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      // Format harga agar lebih rapi (menghilangkan .00)
                      "Rp ${product.price.split('.')[0]}",
                      style: TextStyle(
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
