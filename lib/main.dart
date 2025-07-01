import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // 1. Import GetStorage
import 'package:intl/date_symbol_data_local.dart'; // 1. Import ini
import 'app/routes/app_pages.dart';
import 'initial_bindings.dart';

// 2. Ubah main menjadi async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // 3. Inisialisasi GetStorage
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Terie Bakery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFFDF4EC),
      ),
      initialBinding: InitialBindings(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
