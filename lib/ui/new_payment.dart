import 'package:evidencija_prihoda_rashoda/repository/PaymentRepository.dart';
import 'package:evidencija_prihoda_rashoda/ui/payment_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewPaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();

    PaymentRepository paymentRepo = PaymentRepository();

    return Scaffold(
      appBar: AppBar(title: Text("Isplata novca")),
      body: Container(
        padding: EdgeInsets.only(top: 24, left: 40, right: 40),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Naziv isplate",
              ),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Količina",
              ),
            ),
            ElevatedButton(onPressed: () {
              paymentRepo.removeAmount(titleController.text, amountController.text);
              Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
            }, child: Text('Isplati'))
          ],
        ),
      ),
    );
  }
}
