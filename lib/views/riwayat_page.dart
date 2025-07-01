import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/order_history_controller.dart';
import '../app/routes/app_pages.dart';

class RiwayatPage extends StatelessWidget {
  RiwayatPage({Key? key}) : super(key: key);

  final OrderHistoryController controller = Get.put(OrderHistoryController());
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF6D4C41),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.brown));
        }
        if (controller.orderList.isEmpty) {
          return const Center(
              child: Text('Belum ada riwayat pesanan.',
                  style: TextStyle(fontSize: 18)));
        }
        return RefreshIndicator(
          onRefresh: controller.fetchOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.orderList.length,
            itemBuilder: (context, index) {
              final order = controller.orderList[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: ListTile(
                  onTap: () =>
                      Get.toNamed(Routes.ORDER_DETAIL, arguments: order.id),
                  leading: CircleAvatar(
                    backgroundColor:
                        _getStatusColor(order.status).withOpacity(0.2),
                    child: Icon(_getStatusIcon(order.status),
                        color: _getStatusColor(order.status)),
                  ),
                  title: Text(order.orderNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(DateFormat('d MMMM yyyy, HH:mm', 'id_ID')
                      .format(order.createdAt)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          currencyFormatter
                              .format(double.parse(order.totalPrice)),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(order.status.capitalizeFirst ?? order.status,
                          style:
                              TextStyle(color: _getStatusColor(order.status))),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'shipped':
        return Colors.teal;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_actions;
      case 'processing':
        return Icons.sync;
      case 'shipped':
        return Icons.local_shipping;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
