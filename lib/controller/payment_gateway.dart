import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentGateway extends ChangeNotifier {
  late Razorpay _razorpay;
  BuildContext? _context;

  /// Callback executed by ChoosePayment
  VoidCallback? onPaymentSuccess;

  PaymentGateway() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required double amount,
    required String customerName,
    required String customerPhone,
    required String customerEmail,
    required BuildContext context,
  }) {
    _context = context;

    final options = {
      'key': 'rzp_test_RJHP2rnooxSR65',
      'amount': (amount * 100).toInt(),
      'name': customerName,
      'description': 'Driving School Payment',
      'prefill': {'contact': customerPhone, 'email': customerEmail},
      'theme': {"color": "#3399cc"},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      if (_context != null) {
        ScaffoldMessenger.of(
          _context!,
        ).showSnackBar(const SnackBar(content: Text("Error opening Razorpay")));
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_context != null) {
      ScaffoldMessenger.of(
        _context!,
      ).showSnackBar(const SnackBar(content: Text("Payment Successful")));
    }

    if (onPaymentSuccess != null) {
      onPaymentSuccess!();
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (_context != null) {
      ScaffoldMessenger.of(
        _context!,
      ).showSnackBar(const SnackBar(content: Text("Payment Failed")));
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(content: Text("External Wallet: ${response.walletName}")),
      );
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
