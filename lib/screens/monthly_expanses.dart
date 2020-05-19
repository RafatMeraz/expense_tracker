import 'package:expensetracker/database/database_helper.dart';
import 'package:expensetracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class MonthlyExpenses extends StatefulWidget {
  @override
  _MonthlyExpensesState createState() => _MonthlyExpensesState();
}

enum PopButtons{
  edit,
  delete
}

class _MonthlyExpensesState extends State<MonthlyExpenses> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  List<Expense> allExpanses = [];
  List<Expense> monthlyExpanses = [];
  var totalAmount;
  var month = DateTime.now().month;
  var year = DateTime.now().year;

  Future<void> getAllData() async{
    allExpanses.clear();
    totalAmount = 0.0;
    var listTasks = await DBProvider.db.getAllTasks();
    listTasks.forEach((f){
      var d = DateTime.parse(f.dateTime);
      if (d.month == month && d.year == year){
        allExpanses.add(f);
        totalAmount += f.amount;
      }
    });
    setState(() {
      monthlyExpanses = allExpanses;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: (){
            showModalBottomSheet(context: context, builder: (mContext){
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    child: Text(
                      'Add Expense',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        labelText: 'Title',
                      ),
                      controller: titleController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                        ),
                        labelText: 'Amount',

                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      controller: amountController,
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'ADD',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: ()async{
                          Expense ex = Expense();
                          ex.title = titleController.text;
                          ex.amount = double.parse(amountController.text);
                          ex.dateTime = DateTime.now().toString();
                          await DBProvider.db.addNewTask(ex);
                          titleController.clear();
                          amountController.clear();
                          Toast.show('Expense Added!', context, backgroundColor: Colors.blue, textColor: Colors.white, duration: Toast.LENGTH_SHORT);
                          getAllData();
                        },
                      ),
                    ],
                  )
                ],
              );
            });
          },
        ),
        body: monthlyExpanses.length == 0 ? Center(
          child: Text(
            'Monthly Vault is Empty',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400
            ),
          ),
        ) : Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                 itemCount: monthlyExpanses.length,
                  itemBuilder: (context, index){
                  return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[600], width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        '${monthlyExpanses[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    title: Text(
                        '${monthlyExpanses[index].title}'
                    ),
                    subtitle: Text(
                        '${DateFormat().format(DateTime.parse(monthlyExpanses[index].dateTime))}'
                    ),
                    trailing: PopupMenuButton<PopButtons>(
                        onSelected: (PopButtons result) async{
                          if (result == PopButtons.delete){
                            var d = await DBProvider.db.deleteExpense(monthlyExpanses[index].id);
                            print(d);
                            Toast.show('Expense Deleted!', context,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                duration: Toast.LENGTH_SHORT);
                            getAllData();
                          } else if (result == PopButtons.edit){

                            titleController.text = monthlyExpanses[index].title;
                            amountController.text = monthlyExpanses[index].amount.toString();

                            showModalBottomSheet(context: context, builder: (mContext){
                              return Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(16),
                                    child: Text(
                                      'Edit Expense',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue)
                                        ),
                                        labelText: 'Title',
                                      ),
                                      controller: titleController,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue)
                                        ),
                                        labelText: 'Amount',
                                        errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red)
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      controller: amountController,
                                    ),
                                  ),
                                  ButtonBar(
                                    children: <Widget>[
                                      FlatButton(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red
                                          ),
                                        ),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'UPDATE',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        onPressed: ()async{
                                          Expense ex = Expense();
                                          ex.title = titleController.text;
                                          ex.amount = double.parse(amountController.text);
                                          ex.dateTime = DateTime.now().toString();
                                          ex.id = monthlyExpanses[index].id;
                                          var d = await DBProvider.db.updateClient(ex);
                                          print(d);
                                          Navigator.pop(mContext);
                                          titleController.clear();
                                          amountController.clear();
                                          Toast.show('Expense Updated!', context, backgroundColor: Colors.blue, textColor: Colors.white, duration: Toast.LENGTH_LONG);
                                          getAllData();
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<PopButtons>>[
                          const PopupMenuItem<PopButtons>(
                            value: PopButtons.edit,
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<PopButtons>(
                            value: PopButtons.delete,
                            child: Text('Delete'),
                          ),
                        ]
                    )
                ),
              );
                }),
            ),
            Container(
              width: double.infinity,
              height: 50,
              color: Color(0xFFC6C6C6),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        letterSpacing: .5
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      );
  }
}