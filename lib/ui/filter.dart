import 'package:evidencija_prihoda_rashoda/repository/PaymentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  String type;

  @override
  Widget build(BuildContext context) {
    PaymentRepository paymentRepo = PaymentRepository();
    return Scaffold(
      appBar: AppBar(title: Text("Filtriranje transakcija")),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        type = 'added';
                      });
                    },
                    child: Text('Uplate')),
                SizedBox(width: 24),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        type = 'removed';
                      });
                    },
                    child: Text('Isplate'))
              ],
            ),
            Expanded(
                child: FutureBuilder(
              future: type == null
                  ? paymentRepo.getPaymentList()
                  : paymentRepo.getPaymentListByType(type),
              builder: (_, snap) {
                return ListView.builder(
                    itemCount: snap.data.length,
                    itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      title: Center(
                          child: Column(
                        children: [
                          Text(snap.data.elementAt(index).title),
                          snap.data.elementAt(index).type == "added"
                              ? Text(
                                  "+ ${snap.data.elementAt(index).amount.toString()}",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  "- ${snap.data.elementAt(index).amount.toString()}",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                        ],
                      )),
                    ),
                  );
                });
              },
            ))
          ],
        ),
      ),
    );
  }
}
