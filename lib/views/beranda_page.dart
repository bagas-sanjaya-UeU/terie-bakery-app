import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/product_model.dart';

// Widget BerandaPage tidak perlu diubah, jadi kodenya saya sembunyikan
// untuk fokus pada perbaikan ProductCard.
class BerandaPage extends StatelessWidget {
  BerandaPage({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4EC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchProducts,
          color: Colors.brown,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      _buildSearchBar(),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Kategori"),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildCategoryList(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: _buildSectionTitle("Semua Produk"),
                ),
              ),
              Obx(() {
                if (controller.isLoading.value &&
                    controller.productList.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                        child: CircularProgressIndicator(color: Colors.brown)),
                  );
                }
                if (controller.productList.isEmpty) {
                  return const SliverFillRemaining(
                    child:
                        Center(child: Text("Tidak ada produk yang tersedia.")),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final ProductModel product =
                            controller.productList[index];
                        return ProductCard(
                          product: product,
                          currencyFormatter: currencyFormatter,
                        );
                      },
                      childCount: controller.productList.length,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selamat Datang 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Temukan roti favoritmu!",
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, size: 28),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Cari roti, kue, dan lainnya...",
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCategoryList() {
    final categories = [
      {'icon': Icons.bakery_dining, 'name': 'Roti'},
      {'icon': Icons.cake, 'name': 'Kue'},
      {'icon': Icons.local_drink, 'name': 'Minuman'},
      {'icon': Icons.icecream, 'name': 'Dessert'},
    ];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.brown.shade100,
                  child: Icon(categories[index]['icon'] as IconData,
                      color: Colors.brown, size: 28),
                ),
                const SizedBox(height: 8),
                Text(categories[index]['name'] as String),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- PERBAIKAN ADA DI DALAM WIDGET INI ---
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final NumberFormat currencyFormatter;

  const ProductCard({
    Key? key,
    required this.product,
    required this.currencyFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product.id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                  errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
            // Gunakan `Expanded` dan `Column` yang lebih fleksibel
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Spacer akan mendorong konten di bawahnya ke bagian paling bawah
                    const Spacer(),
                    Text(
                      currencyFormatter.format(double.parse(product.price)),
                      style: TextStyle(
                        color: Colors.brown.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            cartController.addToCart(product);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // Kurangi padding agar tombol tidak terlalu tinggi
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Tambah ke Keranjang",
                            style: TextStyle(fontSize: 14),
                          )),
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
