import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/order_detail_controller.dart';
import '../models/tracking_status_model.dart';

class OrderDetailPage extends GetView<OrderDetailController> {
  OrderDetailPage({Key? key}) : super(key: key);

  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pesanan",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF6D4C41),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.orderDetail.value == null) {
          return const Center(child: Text("Gagal memuat detail pesanan."));
        }

        final order = controller.orderDetail.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pesanan #${order.orderNumber}",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text(
                  "Tanggal: ${DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(order.createdAt)}"),
              const SizedBox(height: 16),
              _buildSection("Status Pelacakan", _buildTrackingTimeline()),
              _buildSection("Produk Dipesan", _buildProductList()),
              _buildSection("Info Pengiriman", _buildShippingInfo()),
              _buildSection("Rincian Pembayaran", _buildPaymentDetails()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(padding: const EdgeInsets.all(12), child: child)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTrackingTimeline() {
    return Obx(() {
      if (controller.isTrackingLoading.value) {
        return const Center(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(strokeWidth: 2)));
      }
      if (controller.trackingList.isEmpty) {
        return const Center(child: Text("Belum ada update pelacakan."));
      }
      return Column(
        children: controller.trackingList
            .map((status) => _buildTimelineTile(status))
            .toList(),
      );
    });
  }

  Widget _buildTimelineTile(TrackingStatusModel status) {
    // ... (kode ini tidak berubah)
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              if (controller.trackingList.last != status)
                Container(height: 40, width: 2, color: Colors.grey.shade300),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(status.status,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(status.description,
                    style: const TextStyle(color: Colors.grey)),
                Text(
                    DateFormat('d MMM y, HH:mm', 'id_ID')
                        .format(status.timestamp),
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- PERBAIKAN DI SINI ---
  Widget _buildProductList() {
    final products = controller.orderDetail.value!.products;
    return Column(
      children: products.map((item) {
        // 'item' sekarang adalah OrderedProductModel
        return ListTile(
          leading: Image.network(
              item.product.imageUrl, // Akses data produk melalui item.product
              width: 50,
              height: 50,
              fit: BoxFit.cover),
          title:
              Text(item.product.name), // Akses data produk melalui item.product
          subtitle: Text(
              "${item.quantity} x ${currencyFormatter.format(double.parse(item.product.price))}"), // Gunakan item.quantity untuk kuantitas
        );
      }).toList(),
    );
  }

  Widget _buildShippingInfo() {
    // ... (kode ini tidak berubah)
    final order = controller.orderDetail.value!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(order.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(order.phone),
        const SizedBox(height: 4),
        Text(order.address),
      ],
    );
  }

  // --- PERBAIKAN DI SINI ---
  Widget _buildPaymentDetails() {
    final order = controller.orderDetail.value!;
    return Column(
      children: [
        _costRow(
            "Subtotal", currencyFormatter.format(double.parse(order.subtotal))),
        _costRow("Ongkos Kirim",
            currencyFormatter.format(double.parse(order.shippingFee))),
        const Divider(),
        _costRow("Total Pembayaran",
            currencyFormatter.format(double.parse(order.totalPrice)),
            isTotal: true),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Status Pembayaran"),
          Text(order.paymentStatus.capitalizeFirst ?? '',
              style: TextStyle(
                  color: order.paymentStatus == 'Sudah Dibayar'
                      ? Colors.green
                      : Colors.orange,
                  fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }

  // Helper widget untuk merapikan kode
  Widget _costRow(String title, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: Colors.grey.shade700)),
          Text(amount,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
