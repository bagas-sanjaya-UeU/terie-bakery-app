import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import package carousel
import '../app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../controllers/cart_controller.dart';
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
              // --- Bagian Banner Baru ---
              SliverToBoxAdapter(
                child: _buildBanners(),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBanners() {
    return Obx(() {
      if (controller.areBannersLoading.value) {
        // Tampilkan placeholder loading
        return Container(
          height: 150,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
        return const SizedBox
            .shrink(); // Jangan tampilkan apa-apa jika tidak ada banner
      }

      return CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
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
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(url, fit: BoxFit.cover),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }
}

// ProductCard tidak perlu diubah
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
                      maxLines: 2,
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
