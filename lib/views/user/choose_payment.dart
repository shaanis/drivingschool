import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivingschool/controller/payment_gateway.dart';
import 'package:drivingschool/controller/user_controller.dart';

class ChoosePayment extends StatefulWidget {
  final double price;
  final String courseId; // now using courseId
  final String courseName; // optional, for display only
  final String userName;
  final String userPhone;
  final String userEmail;

  const ChoosePayment({
    super.key,
    required this.price,
    required this.courseId,
    required this.courseName,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
  });

  @override
  State<ChoosePayment> createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {
  late PaymentGateway paymentGateway;
  late UserController userController;

  @override
  void initState() {
    super.initState();

    paymentGateway = Provider.of<PaymentGateway>(context, listen: false);
    userController = Provider.of<UserController>(context, listen: false);

    paymentGateway.onPaymentSuccess = () async {
      // Update course using ID
      await userController.updateCourse(widget.courseId);

      if (!mounted) return;
      Navigator.pop(context, true);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.courseName, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(
              "Price: ₹${widget.price}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                paymentGateway.openCheckout(
                  amount: widget.price,
                  customerName: widget.userName,
                  customerPhone: widget.userPhone,
                  customerEmail: widget.userEmail,
                  context: context,
                );
              },
              child: const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
