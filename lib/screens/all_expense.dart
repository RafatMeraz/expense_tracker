import 'package:expensetracker/database/database_helper.dart';
import 'package:expensetracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../utils/reuseable_eidgets.dart';

class AllExpense extends StatefulWidget {
  @override
  _AllExpenseState createState() => _AllExpenseState();
}

enum PopButtons{
  edit,
  delete
}

class _AllExpenseState extends State<AllExpense> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  List<Expense> transactions = [];
  List<Expense> todayTrans = [];

  Future<void> _getRecords() async {
    var res = await DBProvider.db.getAllTasks();
    setState((){
      transactions = res;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRecords();
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
                        _getRecords();
                      },
                    ),
                  ],
                )
              ],
            );
          });
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: transactions.length == 0 ? Center(
              child: Text(
                'Vault is Empty',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
              ),
            ) : ListView.builder(
              itemCount: transactions.length,
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
                        '${transactions[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    title: Text(
                        '${transactions[index].title}'
                    ),
                    subtitle: Text(
                        '${DateFormat().format(DateTime.parse(transactions[index].dateTime))}'
                    ),
                    trailing: PopupMenuButton<PopButtons>(
                      onSelected: (PopButtons result) async{
                        if (result == PopButtons.delete){
                          var d = await DBProvider.db.deleteExpense(transactions[index].id);
                          print(d);
                          Toast.show('Expense Deleted!', context,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              duration: Toast.LENGTH_SHORT);
                          _getRecords();
                        } else if (result == PopButtons.edit){

                          titleController.text = transactions[index].title;
                          amountController.text = transactions[index].amount.toString();

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
                                        ex.id = transactions[index].id;
                                        var d = await DBProvider.db.updateClient(ex);
                                        print(d);
                                        Navigator.pop(mContext);
                                        titleController.clear();
                                        amountController.clear();
                                        Toast.show('Expense Updated!', context, backgroundColor: Colors.blue, textColor: Colors.white, duration: Toast.LENGTH_LONG);
                                        _getRecords();
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
              },
            ),
          )
        ],
      ),
    );
  }
}