import 'package:get/get.dart';

// Import semua halaman (views) Anda
import '../../../../views/splash_screen.dart';
import '../../../../views/login_page.dart';
import '../../../../views/register_page.dart';
import '../../../../views/forgot_password_page.dart';
import '../../../../views/home_page.dart';
import '../../../../views/keranjang_page.dart';
import '../../../../views/checkout_page.dart';
import '../../../../views/product_detail_page.dart';
import '../../bindings/product_detail_binding.dart';
import '../../bindings/checkout_binding.dart';
import '../../../../views/payment_page.dart' as payment;
import '../../../../views/transaction_success_page.dart';
import '../../../../views/transaction_failed_page.dart';
import '../../../../views/transaction_cancel_page.dart';
import '../../../../views/transaction_expired_page.dart';
import '../../../../views/order_detail_page.dart';
import '../../bindings/order_detail_binding.dart';
import '../../../../views/edit_profile_page.dart';
import '../../bindings/edit_profile_binding.dart';

// Import file routes
part 'app_routes.dart';

class AppPages {
  // Definisikan halaman awal di sini
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.KERANJANG,
      page: () => KeranjangPage(),
    ),

    // ... (di dalam file app_pages.dart)
    GetPage(
      name: Routes.PRODUCT_DETAIL,
      page: () => ProductDetailPage(),
      binding: ProductDetailBinding(), // Tambahkan binding ini
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => CheckoutPage(),
      binding: CheckoutBinding(), // Tambahkan binding ini
    ),
    // Tambahkan rute untuk halaman payment (halamannya bisa dibuat nanti)
    // --- KONFIGURASI RUTE PEMBAYARAN ---
    GetPage(
      name: Routes.PAYMENT,
      // Saat rute ini dipanggil, kita buat PaymentPage.
      // `Get.arguments` akan berisi `paymentToken` yang dikirim dari controller.
      page: () => payment.PaymentPage(snapToken: Get.arguments as String),
    ),
    GetPage(
      name: Routes.TRANSACTION_SUCCESS,
      page: () => TransactionSuccessPage(),
    ),
    GetPage(
      name: Routes.TRANSACTION_FAILED,
      page: () =>
          TransactionFailedPage(), // Make sure this matches the class name in transaction_failed_page.dart
    ),
    GetPage(
      name: Routes.TRANSACTION_CANCEL,
      page: () => TransactionCancelPage(),
    ),
    GetPage(
      name: Routes.TRANSACTION_EXPIRED,
      page: () => TransactionExpiredPage(),
    ),

    GetPage(
      name: Routes.ORDER_DETAIL,
      page: () => OrderDetailPage(),
      binding: OrderDetailBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => EditProfilePage(),
      binding: EditProfileBinding(),
    ),
// ...
  ];
}
