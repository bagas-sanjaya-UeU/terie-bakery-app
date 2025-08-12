part of 'app_pages.dart'; // Ini akan menghubungkan file ini dengan app_pages.dart

abstract class Routes {
  // Nama-nama ini bisa Anda gunakan di seluruh aplikasi untuk navigasi
  // contoh: Get.toNamed(Routes.LOGIN);
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const VERIFY_OTP = '/verify-otp';
  static const RESET_PASSWORD = '/reset-password';
  static const HOME = '/home';
  static const KERANJANG = '/keranjang';
  static const CHECKOUT = '/checkout';
  static const PRODUCT_DETAIL = '/product-detail';
  static const PAYMENT = '/payment';
  static const TRANSACTION_SUCCESS = '/transaction-success';
  static const TRANSACTION_FAILED = '/transaction-failed';
  static const TRANSACTION_CANCEL = '/transaction-cancel';
  static const TRANSACTION_EXPIRED = '/transaction-expired';
  static const ORDER_DETAIL = '/order-detail';
  static const EDIT_PROFILE = '/edit-profile';
}
