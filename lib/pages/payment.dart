// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  _PaymentSectionState createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  List<PaymentItem> pendingPayments = [
    PaymentItem(id: "1", description: "Tuition Fee", amount: 400000.00),
    PaymentItem(id: "2", description: "Hostel Fee", amount: 200000.00),
    PaymentItem(id: "3", description: "Library Fine", amount: 20000.00),
  ];

  List<PaymentItem> paidPayments = [
    PaymentItem(id: "4", description: "Exam Fee", amount: 300000.00),
    PaymentItem(id: "5", description: "Sports Fee", amount: 150000.00),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Outstanding Fees",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 10),
            _buildPaymentList(pendingPayments),
            const SizedBox(height: 20),
            const Text(
              "Already Paid",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 10),
            _buildPaymentList(paidPayments),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentList(List<PaymentItem> payments) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: const Icon(Icons.payment, color: Colors.blue),
            title: Text(payment.description),
            subtitle: Text("\$${payment.amount.toStringAsFixed(2)}"),
            trailing: Flexible(
              child: ElevatedButton(
                onPressed: () async {
                  await _processPayment(payment);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text("Pay"),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _processPayment(PaymentItem payment) async {
    // Here you can integrate with your payment gateway or API to process the payment
    // For demonstration purposes, we'll just print a message indicating that the payment was successful
    showModalBottomSheet(
      context: context,
      builder: (context) => PaymentForm(payment: payment),
    );
  }
}

/// Demo payment sheet. It deliberately has no card fields: a real portal
/// would hand payment to a provider's own checkout or SDK, so card details
/// never pass through this app.
class PaymentForm extends StatelessWidget {
  final PaymentItem payment;

  const PaymentForm({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${payment.description}: \$${payment.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'This is a demo, so no card details are collected and no money '
            'is taken. A real portal would send you to a payment provider\'s '
            'own checkout.',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Demo payment of \$${payment.amount.toStringAsFixed(2)} recorded',
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Confirm demo payment'),
          ),
        ],
      ),
    );
  }
}

class PaymentItem {
  final String id;
  final String description;
  final double amount;

  PaymentItem({required this.id, required this.description, required this.amount});
}