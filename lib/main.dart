import 'package:evidencija_prihoda_rashoda/ui/add_finances.dart';
import 'package:evidencija_prihoda_rashoda/ui/login.dart';
import 'package:evidencija_prihoda_rashoda/ui/new_payment.dart';
import 'package:evidencija_prihoda_rashoda/ui/payment_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new PaymentHistoryScreen(),
          '/new-payment': (BuildContext context) => new NewPaymentScreen(),
          '/add-finances': (BuildContext context) => new AddFinancesScreen(),
        },
        title: 'Evidencija prihoda',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: FirebaseAuth.instance.currentUser != null
            ? PaymentHistoryScreen()
            : LoginScreen());
  }
}
