import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/profile_controller.dart'; // 1. Import ProfileController
import '../controllers/main_controller.dart'; // 2. Import MainController untuk navigasi tab
import '../models/product_model.dart';

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
          onRefresh: controller.refreshHomePage, // Panggil fungsi refresh baru
          color: Colors.brown,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildHeader(),
                ),
              ),
              // --- Bagian Banner ---
              SliverToBoxAdapter(
                child: _buildBanners(),
              ),

              // --- BAGIAN PRODUK TERLARIS BARU ---
              SliverToBoxAdapter(
                child: _buildBestsellersSection(),
              ),

              // --- Bagian Semua Produk ---
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
    // 3. Dapatkan instance ProfileController dan MainController
    final ProfileController profileController = Get.find();
    final MainController mainController = Get.find();

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
        // 4. Gunakan Obx untuk membuat avatar reaktif
        Obx(() {
          final user = profileController.user.value;
          final imageUrl = user?.imageUrl;
          final initials = user?.name.isNotEmpty ?? false
              ? user!.name
                  .trim()
                  .split(' ')
                  .map((l) => l[0])
                  .take(2)
                  .join()
                  .toUpperCase()
              : 'U';

          return GestureDetector(
            onTap: () {
              // 5. Pindah ke tab profil (index 3) saat avatar diklik
              mainController.changeTabIndex(3);
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.brown.shade100,
              backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl)
                  : null,
              child: (imageUrl == null || imageUrl.isEmpty)
                  ? Text(initials,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.brown))
                  : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBanners() {
    return Obx(() {
      if (controller.areBannersLoading.value) {
        return Container(
          height: 150,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.brown)),
        );
      }

      final List<String> imageUrls = [];
      if (controller.banners.value?.storeBanner?.imageUrl != null) {
        imageUrls.add(controller.banners.value!.storeBanner!.imageUrl);
      }
      if (controller.banners.value?.storeBannerKedua?.imageUrl != null) {
        imageUrls.add(controller.banners.value!.storeBannerKedua!.imageUrl);
      }

      if (imageUrls.isEmpty) {
        return const SizedBox.shrink();
      }

      return CarouselSlider(
        options: CarouselOptions(
          height: 188.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
          viewportFraction: 0.85,
        ),
        items: imageUrls.map((url) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(url,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(Icons.error)),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }

  Widget _buildBestsellersSection() {
    return Obx(() {
      if (controller.areBestsellersLoading.value) {
        return const SizedBox(
            height: 220,
            child:
                Center(child: CircularProgressIndicator(color: Colors.brown)));
      }
      if (controller.bestsellerList.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: _buildSectionTitle("Produk Terlaris 🔥"),
          ),
          SizedBox(
            height: 150, // Tinggi list dikecilkan
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.bestsellerList.length,
              itemBuilder: (context, index) {
                final product = controller.bestsellerList[index];
                return Container(
                  width: 110, // Lebar kartu dikecilkan
                  margin: const EdgeInsets.only(right: 12),
                  // Gunakan widget kartu baru yang lebih kecil
                  child: BestsellerCard(
                    product: product,
                    currencyFormatter: currencyFormatter,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

// --- WIDGET BARU UNTUK KARTU PRODUK TERLARIS ---
class BestsellerCard extends StatelessWidget {
  final ProductModel product;
  final NumberFormat currencyFormatter;

  const BestsellerCard({
    Key? key,
    required this.product,
    required this.currencyFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormatter.format(double.parse(product.price)),
                    style: TextStyle(
                      color: Colors.brown.shade800,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Tambah"),
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
