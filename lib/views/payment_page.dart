import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import '../app/routes/app_pages.dart';

class PaymentPage extends StatefulWidget {
  final String snapToken;

  const PaymentPage({Key? key, required this.snapToken}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _webViewController;
  bool hasNavigated = false;

  @override
  void initState() {
    super.initState();

    final Uri paymentUrl =
        Uri.parse("https://app.midtrans.com/snap/v2/vtweb/${widget.snapToken}");

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(paymentUrl)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            if (change.url != null) {
              print('URL Changed: ${change.url}');
              _handleTransactionStatus(change.url!);
            }
          },
        ),
      );
  }

  void _handleTransactionStatus(String url) {
    if (!mounted || hasNavigated) return;

    if (url.contains('transaction_status=settlement')) {
      hasNavigated = true;
      Get.offAllNamed(Routes.TRANSACTION_SUCCESS);
    } else if (url.contains('transaction_status=deny')) {
      hasNavigated = true;
      Get.offAllNamed(Routes.TRANSACTION_FAILED);
    } else if (url.contains('transaction_status=cancel')) {
      hasNavigated = true;
      Get.offAllNamed(Routes.TRANSACTION_CANCEL);
    } else if (url.contains('#/407')) {
      // Midtrans error code for expired
      hasNavigated = true;
      Get.offAllNamed(Routes.TRANSACTION_EXPIRED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: const Color(0xFF6D4C41),
      ),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}
