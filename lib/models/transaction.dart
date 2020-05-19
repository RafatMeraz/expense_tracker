import 'package:flutter/foundation.dart';

class Expense {
  int id;
  String title;
  double amount;
  String dateTime;

  Expense();

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = this.id;
    }
    map['title'] = this.title;
    map['amount'] = this.amount;
    map['date'] = this.dateTime;

    return map;
  }
  Map<String, dynamic> toMapUpdate() {

    var map = Map<String, dynamic>();

    map['title'] = this.title;
    map['amount'] = this.amount;
    map['date'] = this.dateTime;

    return map;
  }

  Expense.fromMap(Map<String, dynamic> map) {
    this.id = map['_id'];
    this.title = map['title'];
    this.dateTime = map['date'];
    this.amount = map['amount'];
  }
}