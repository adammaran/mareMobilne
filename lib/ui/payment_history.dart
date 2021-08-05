import 'package:evidencija_prihoda_rashoda/repository/PaymentRepository.dart';
import 'package:evidencija_prihoda_rashoda/ui/add_finances.dart';
import 'package:evidencija_prihoda_rashoda/ui/filter.dart';
import 'package:evidencija_prihoda_rashoda/ui/login.dart';
import 'package:evidencija_prihoda_rashoda/ui/new_payment.dart';
import 'package:evidencija_prihoda_rashoda/ui/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PaymentHistoryScreenState();
}

class PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  int amount;

  @override
  void initState() {
    PaymentRepository paymentRepo = PaymentRepository();
    paymentRepo.getCurrentAmount().then((value) => amount = value);
    super.initState();
  }

  @override
  void didUpdateWidget(PaymentHistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PaymentRepository paymentRepo = PaymentRepository();
    return Scaffold(
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: 30),
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.arrow_downward),
                title: Text('Uplata na račun'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddFinancesScreen()));
                }),
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text('Isplata sa računa'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewPaymentScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text('Pretraga'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.filter_alt),
              title: Text('Filter'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FilterScreen()));
              },
            ),
            ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }),
          ],
        ),
      ),
      appBar: AppBar(
          title: Text("Istorija plaćanja"), automaticallyImplyLeading: false),
      body: FutureBuilder(
          future: paymentRepo.getCurrentAmount(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    amount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
                FutureBuilder(
                    future: paymentRepo.getPaymentList(),
                    builder: (context, snap) {
                      if (snap.hasData) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snap.data.length,
                              itemBuilder: (_, index) {
                                return Card(
                                  child: ListTile(
                                    title: Center(
                                        child: Column(
                                      children: [
                                        Text(snap.data.elementAt(index).title),
                                        snap.data.elementAt(index).type ==
                                                "added"
                                            ? Text(
                                                "+ ${snap.data.elementAt(index).amount.toString()}",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                "- ${snap.data.elementAt(index).amount.toString()}",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                      ],
                                    )),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return Center(child: Text("Nema transakcija"));
                      }
                    })
              ],
            );
          }),
    );
  }
}
