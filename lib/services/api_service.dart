import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/product_model.dart'; // Import model produk
import '../models/user_model.dart';

import '../models/cart_model.dart'; // Import CartModel
import '../models/checkout_response_model.dart';
import '../models/order_summary_model.dart';
import '../models/order_detail_model.dart';
import '../models/tracking_status_model.dart';

class ApiService {
  final String _baseUrl = "https://terie-bakery.biz.id/api";
  final _storage = GetStorage(); // Instance GetStorage

  String? get _token => _storage.read('access_token');
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };
  // 2. Ubah tipe data kembalian dari Future<bool> menjadi Future<UserModel>
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      // Cek jika response sukses (kode 200) DAN flag 'success' dari API adalah true
      if (response.statusCode == 200 && data['success'] == true) {
        // 3. Simpan access token seperti sebelumnya
        await _storage.write('access_token', data['data']['access_token']);
        print("Login successful, token saved!");

        // 4. Buat instance UserModel dari data JSON
        UserModel user = UserModel.fromJson(data['data']['user']);

        // 5. Kembalikan objek user yang sudah jadi
        return user;
      } else {
        // Jika gagal, lempar pesan error dari server
        throw Exception(data['message'] ?? 'Login gagal, silahkan coba lagi.');
      }
    } catch (e) {
      // Tangkap semua jenis error (network, parsing, dll)
      print("Error during login: $e");
      // Umpan balik error ke controller dengan pesan yang lebih bersih
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password, // API biasanya butuh ini
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        // Status code untuk create biasanya 201
        // Langsung simpan token agar user bisa langsung login
        await _storage.write('access_token', data['data']['access_token']);
        print("Register successful, token saved!");

        // Ubah data user menjadi UserModel
        UserModel user = UserModel.fromJson(data['data']['user']);
        return user;
      } else {
        // Handle error validasi dari server (misal: email sudah terdaftar)
        String errorMessage = data['message'] ?? 'Registrasi gagal.';
        if (data['errors'] != null) {
          errorMessage = data['errors'].values.first[0];
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("Error during register: $e");
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final token = _storage.read('access_token');
    if (token == null) {
      throw Exception('Unauthorized: No token found.');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Sertakan token di header
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Data produk ada di dalam list 'data' di dalam objek 'data'
        final List<dynamic> productListJson = data['data']['data'];

        // Ubah setiap item di list JSON menjadi objek ProductModel
        List<ProductModel> products =
            productListJson.map((json) => ProductModel.fromJson(json)).toList();

        return products;
      } else {
        throw Exception(data['message'] ?? 'Gagal mengambil data produk.');
      }
    } catch (e) {
      print("Error fetching products: $e");
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<ProductModel> getProductDetail(int productId) async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/products/$productId'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Data detail produk ada di dalam 'data'
        return ProductModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Gagal mengambil detail produk.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // --- FUNGSI ADD TO CART (BARU) ---
  // --- FUNGSI ADD TO CART (DIPERBAIKI) ---
  Future<void> addToCart({
    required int productId,
    required int quantity,
  }) async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/cart'),
        headers: _headers,
        body: jsonEncode({
          'product_id': productId,
          'quantity': quantity,
        }),
      );

      final data = jsonDecode(response.body);

      // --- INI PERBAIKANNYA ---
      // Kita hanya perlu memeriksa flag 'success' dari API.
      // Jika API bilang tidak sukses, baru kita lempar error.
      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Gagal menambahkan ke keranjang.');
      }

      // Jika 'success' adalah true, fungsi akan selesai tanpa error,
      // dan blok 'try' di controller akan berjalan normal.
    } catch (e) {
      // Melempar kembali error agar bisa ditangkap oleh controller
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<CartModel> getCart() async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/cart'), headers: _headers);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return CartModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Gagal mengambil data keranjang.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updateCartItemQuantity(
      {required int cartItemId, required int quantity}) async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/cart/$cartItemId'),
        headers: _headers,
        body: jsonEncode({'quantity': quantity}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(data['message'] ?? 'Gagal memperbarui kuantitas.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteCartItem({required int cartItemId}) async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/cart/$cartItemId'),
        headers: _headers,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode != 200 || data['success'] != true) {
        throw Exception(data['message'] ?? 'Gagal menghapus item.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<CheckoutResponseModel> checkout({
    required String name,
    required String address,
    required String phone,
    required double shippingFee,
  }) async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/checkout'),
        headers: _headers,
        body: jsonEncode({
          'name': name,
          'address': address,
          'phone': phone,
          'shipping_fee':
              shippingFee.toInt(), // API sepertinya menerima integer
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return CheckoutResponseModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Proses checkout gagal.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<OrderSummaryModel>> getOrders() async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/orders'), headers: _headers);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        final List<dynamic> orderListJson = data['data']['data'];
        return orderListJson
            .map((json) => OrderSummaryModel.fromJson(json))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Gagal mengambil riwayat pesanan.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<OrderDetailModel> getOrderDetail(int orderId) async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');
    try {
      final response = await http.get(Uri.parse('$_baseUrl/orders/$orderId'),
          headers: _headers);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return OrderDetailModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Gagal mengambil detail pesanan.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<TrackingStatusModel>> getOrderTracking(int orderId) async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/orders/$orderId/track'), headers: _headers);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        final List<dynamic> trackingListJson = data['data'];
        return trackingListJson
            .map((json) => TrackingStatusModel.fromJson(json))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Gagal mengambil data pelacakan.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<UserModel> getProfile() async {
    if (_token == null)
      throw Exception('Sesi berakhir. Silakan login kembali.');

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Data profil ada di dalam 'data'
        return UserModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Gagal mengambil data profil.');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> logout() async {
    await _storage.remove('access_token');
    // Jika API Anda punya endpoint untuk logout, panggil di sini
  }

  String? getToken() {
    return _storage.read('access_token');
  }
}
