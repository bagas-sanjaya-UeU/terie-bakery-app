import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';

class CheckoutPage extends GetView<CheckoutController> {
  CheckoutPage({Key? key}) : super(key: key);

  final CartController cartController = Get.find();
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout Pesanan",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF6D4C41),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
                "Ringkasan Pesanan", Icons.shopping_bag_outlined),
            _buildOrderSummary(),
            const SizedBox(height: 24),
            _buildSectionTitle(
                "Detail Pengiriman", Icons.local_shipping_outlined),
            _buildShippingDetails(),
            const SizedBox(height: 24),
            _buildSectionTitle(
                "Tanggal Diterima Di tempat", Icons.calendar_today_outlined),
            _buildSchedulePicker(context),
            const SizedBox(height: 24),
            _buildSectionTitle("Rincian Biaya", Icons.receipt_long_outlined),
            _buildCostDetails(),
          ],
        ),
      ),
      bottomNavigationBar: _buildCheckoutButton(),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown.shade700),
          const SizedBox(width: 8),
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 200), // Batasi tinggi
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartController.cartItems[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(item.product.imageUrl,
                    width: 50, height: 50, fit: BoxFit.cover),
              ),
              title: Text(item.product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  "${item.quantity} x ${currencyFormatter.format(double.parse(item.product.price))}"),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShippingDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: controller.nameC,
                decoration: const InputDecoration(
                    labelText: "Nama Penerima", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(
                controller: controller.phoneC,
                decoration: const InputDecoration(
                    labelText: "Nomor Telepon", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            TextField(
                controller: controller.addressC,
                decoration: const InputDecoration(
                    labelText: "Alamat Lengkap", border: OutlineInputBorder()),
                maxLines: 3),
            const SizedBox(height: 12),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isFetchingLocation.value
                        ? null
                        : controller.getCurrentLocation,
                    icon: controller.isFetchingLocation.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.my_location),
                    label: const Text("Gunakan Lokasi Saat Ini"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade300,
                      foregroundColor: Colors.black,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulePicker(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.pickOrderDateTime(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.selectedDateTime.value == null) {
                    return const Text("Pilih tanggal & waktu Diterima");
                  } else {
                    // Format tanggal dan waktu yang dipilih
                    final formattedDate =
                        DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id_ID')
                            .format(controller.selectedDateTime.value!);
                    return Text(
                      formattedDate,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    );
                  }
                }),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCostDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              children: [
                // PERBAIKAN DI SINI: Gunakan subtotal, bukan totalPrice
                _costRow("Subtotal Pesanan",
                    currencyFormatter.format(cartController.subtotal.value)),
                const Divider(height: 20),
                _costRow(
                    "Ongkos Kirim (${controller.distanceInKm.value.toStringAsFixed(1)} km)",
                    currencyFormatter.format(controller.shippingFee.value)),
                const Divider(height: 20, thickness: 2),
                // PERBAIKAN DI SINI: Gunakan subtotal, bukan totalPrice
                _costRow(
                    "Total Pembayaran",
                    currencyFormatter.format(cartController.subtotal.value +
                        controller.shippingFee.value),
                    isTotal: true),
              ],
            )),
      ),
    );
  }

  Widget _costRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(amount,
            style: TextStyle(
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.processCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white))
                  : const Text("Proses Pesanan",
                      style: TextStyle(color: Colors.white)),
            ),
          )),
    );
  }
}
