import 'package:get/get.dart';
import '../models/order_summary_model.dart';
import '../services/api_service.dart';

class OrderHistoryController extends GetxController {
  final ApiService apiService = Get.find();

  var orderList = <OrderSummaryModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      final orders = await apiService.getOrders();
      orderList.assignAll(orders);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
