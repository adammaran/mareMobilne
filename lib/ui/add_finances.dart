import 'package:evidencija_prihoda_rashoda/repository/PaymentRepository.dart';
import 'package:evidencija_prihoda_rashoda/ui/payment_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFinancesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    PaymentRepository paymentRepo = PaymentRepository();

    return Scaffold(
      appBar: AppBar(title: Text("Dodavanje novca")),
      body: Container(
        padding: EdgeInsets.only(top: 24, left: 40, right: 40),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Naziv uplate",
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: amountController,
              decoration: InputDecoration(
                hintText: "Količina",
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  paymentRepo.addAmount(
                      titleController.text, amountController.text);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentHistoryScreen()),
                      (r) => false);
                },
                child: Text('Dodaj'))
          ],
        ),
      ),
    );
  }
}
