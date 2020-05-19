import 'package:expensetracker/screens/all_expense.dart';
import 'package:expensetracker/screens/today_expenses.dart';
import 'package:expensetracker/screens/monthly_expanses.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expensetracker/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:toast/toast.dart';
import '../database/database_helper.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Center(
            child: Text(
              'Expense Tracker'
            ),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.grey[600],
            tabs: <Widget>[
              Tab(
                icon: Icon(
                    Icons.list,
                    size: 25
                ),
                text: 'All',
              ),
              Tab(
                icon: Icon(
                    Icons.today,
                    size: 25
                ),
                text: 'Today',
              ),
              Tab(
                icon: Icon(
                    Icons.calendar_today,
                    size: 25
                ),
                text: 'Monthly',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            AllExpense(),
            TodayExpense(),
            MonthlyExpenses(),
          ],
        )
      ),
    );
  }
}


