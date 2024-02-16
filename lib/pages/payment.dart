import 'package:flutter/material.dart';

class PendingPayment {
  final String id;
  final String description;
  final double amount;

  PendingPayment({required this.id, required this.description, required this.amount});
}

List<PendingPayment> pendingPayments = [
  PendingPayment(id: "1", description: "Tuition Fee", amount: 400000.00),
  PendingPayment(id: "2", description: "Hostel Fee", amount: 200000.00),
  PendingPayment(id: "3", description: "Library Fine", amount: 20000.00),
];

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  PaymentState createState() => PaymentState();
}

class PaymentState extends State<Payment> {
  List<PendingPayment> pendingPayments = [
    PendingPayment(id: "1", description: "Tuition Fee", amount: 400000.00),
    PendingPayment(id: "2", description: "Hostel Fee", amount: 200000.00),
    PendingPayment(id: "3", description: "Library Fine", amount: 20000.00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Processing"),
      ),
      body: ListView.builder(
        itemCount: pendingPayments.length,
        itemBuilder: (context, index) {
          final payment = pendingPayments[index];
          return ListTile(
            title: Text(payment.description),
            subtitle: Text("#${payment.amount}"),
            trailing: IconButton(
              icon: const Icon(Icons.payment),
              onPressed: () {
                // Placeholder for payment logic
                print("Paying ${payment.description}");
                _processPayment(payment);
              },
            ),
          );
        },
      ),
    );
  }

  void _processPayment(PendingPayment payment) {
    // Here, you would integrate with your payment gateway.
    // This example simply shows a dialog as a placeholder.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Pay ${payment.description}"),
        content: Text("Pretend payment of \#${payment.amount} was successful."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}