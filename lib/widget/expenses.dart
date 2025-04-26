import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widget/expense_list/expense_list.dart';
import 'package:expense_tracker/widget/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerdExpense = [
    Expense(title: "Food", amount: 20, date: DateTime.now(), category: Category.food),
    Expense(title: "Entertainment", amount: 50, date: DateTime.now(), category: Category.entertainment),
    Expense(title: "Other", amount: 200, date: DateTime.now(), category: Category.other),
    Expense(title: "Travel", amount: 20, date: DateTime.now(), category: Category.travel),
  ];

  void _openAddExpenseScreen(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _registerdExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense){

    final expenseIndex = _registerdExpense.indexOf(expense);
    setState(() {
      _registerdExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text("Expense Deleted", style: TextStyle(fontSize: 16),),
        action: SnackBarAction(label: "Undo", onPressed: (){
          setState(() {
            _registerdExpense.insert(expenseIndex, expense);
          });
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Widget mainContent = const Center(
      child: Text("No Expense Found"),
    );

    if(_registerdExpense.isNotEmpty){
      mainContent = ExpensesList(expenses: _registerdExpense, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(onPressed: _openAddExpenseScreen, icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
          Text("Chart"),
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}