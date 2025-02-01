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

class PaymentForm extends StatefulWidget {
  final PaymentItem payment;

  const PaymentForm({super.key, required this.payment});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your card number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expirationDateController,
                  decoration: const InputDecoration(labelText: 'Expiration Date'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your expiration date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your CVV';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Here you can integrate with your payment gateway or API to process the payment
// For demonstration purposes, we'll just print a message indicating that the payment was successful
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payment of \$${widget.payment.amount.toStringAsFixed(2)} successful')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Pay'),
                ),
              ],
            ),
          ),
        ),
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