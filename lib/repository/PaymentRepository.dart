import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evidencija_prihoda_rashoda/models/payment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentRepository {
  final _databaseReference = FirebaseFirestore.instance;

  Future<List<Payment>> getPaymentList() async {
    List<Payment> paymentList = [];
    QuerySnapshot doc = await _databaseReference
        .collection('payment_history')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get();
    doc.docs.forEach((element) {
      paymentList.add(Payment.create(
          amount: int.parse(element.get('amount')),
          title: element.get('title'),
          type: element.get('type'),
          id: element.get('id')));
    });
    return paymentList;
  }

  Future<List<Payment>> getPaymentListByType(type) async {
    List<Payment> paymentList = [];
    QuerySnapshot doc = await _databaseReference
        .collection('payment_history')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .where('type', isEqualTo: type)
        .get();
    doc.docs.forEach((element) {
      paymentList.add(Payment.create(
          amount: int.parse(element.get('amount')),
          title: element.get('title'),
          type: element.get('type'),
          id: element.get('id')));
    });
    return paymentList;
  }

  Future<int> getCurrentAmount() async {
    DocumentSnapshot doc = await _databaseReference
        .collection('money_status')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    return doc.get('amount');
  }

  void addAmount(title, amount) async {
    int newAmount = await getCurrentAmount() + int.parse(amount);

    _databaseReference
        .collection('money_status')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({'amount': newAmount});
    addPaymentToHistory(title, amount, 'added');
  }

  void removeAmount(title, amount) async {
    int newAmount = await getCurrentAmount() - int.parse(amount);

    _databaseReference
        .collection('money_status')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({'amount': newAmount});
    addPaymentToHistory(title, amount, 'removed');
  }

  void addPaymentToHistory(title, amount, type) async {
    _databaseReference.collection('payment_history').add({
      'title': title,
      'amount': amount,
      'uid': FirebaseAuth.instance.currentUser.uid,
      'type': type
    }).then((value) {
      _databaseReference
          .collection('payment_history')
          .doc(value.id)
          .update({'id': value.id});
    });
  }

  void deleteTransaction(id) async {
    _databaseReference.collection('payment_history').doc(id).delete();
  }
}
