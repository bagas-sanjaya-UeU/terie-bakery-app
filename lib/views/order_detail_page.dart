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
      appBar: AppBar(title: const Text("Detail Pesanan")),
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
      return Column(
        children: controller.trackingList
            .map((status) => _buildTimelineTile(status))
            .toList(),
      );
    });
  }

  Widget _buildTimelineTile(TrackingStatusModel status) {
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

  Widget _buildProductList() {
    final products = controller.orderDetail.value!.products;
    return Column(
      children: products
          .map((product) => ListTile(
                leading: Image.network(product.imageUrl,
                    width: 50, height: 50, fit: BoxFit.cover),
                title: Text(product.name),
                trailing:
                    Text(currencyFormatter.format(double.parse(product.price))),
              ))
          .toList(),
    );
  }

  Widget _buildShippingInfo() {
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

  Widget _buildPaymentDetails() {
    final order = controller.orderDetail.value!;
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Total Pesanan"),
          Text(currencyFormatter.format(double.parse(order.totalPrice))),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Status Pembayaran"),
          Text(order.paymentStatus.capitalizeFirst ?? '',
              style: TextStyle(
                  color: order.paymentStatus == 'paid'
                      ? Colors.green
                      : Colors.orange,
                  fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }
}
