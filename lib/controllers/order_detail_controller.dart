import 'package:get/get.dart';
import 'dart:async';
import '../models/order_detail_model.dart';
import '../models/tracking_status_model.dart';
import '../services/api_service.dart';

class OrderDetailController extends GetxController {
  final ApiService apiService = Get.find();
  final int orderId = Get.arguments as int;

  var orderDetail = Rxn<OrderDetailModel>();
  var trackingList = <TrackingStatusModel>[].obs;
  var isLoading = true.obs;
  var isTrackingLoading = true.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
    // Mulai polling untuk data tracking setiap 10 detik
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchTracking();
    });
  }

  @override
  void onClose() {
    _timer?.cancel(); // Hentikan timer saat halaman ditutup
    super.onClose();
  }

  Future<void> fetchDetails() async {
    try {
      isLoading(true);
      orderDetail.value = await apiService.getOrderDetail(orderId);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTracking() async {
    // Jangan tampilkan loading indicator untuk refresh background
    isTrackingLoading.value = trackingList.isEmpty;
    try {
      final trackingData = await apiService.getOrderTracking(orderId);
      trackingList.assignAll(trackingData);
    } catch (e) {
      print("Failed to update tracking: $e");
    } finally {
      isTrackingLoading.value = false;
    }
  }
}
