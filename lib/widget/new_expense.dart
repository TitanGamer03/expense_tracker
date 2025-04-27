import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget{
  const NewExpense({super.key, required this.onAddExpense});

  final Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {

    if(Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (ctx) =>
        CupertinoAlertDialog(
          title: Text("Invalid Input"),
          content: Text("Enter Valid Value"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    }
    else {
      showDialog(context: context, builder: (ctx) =>
        AlertDialog(
          title: Text("Invalid Input"),
          content: Text("Enter Valid Value"),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(ctx);
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
     _titleController.dispose();
     _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (ctx, constraints) {

      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyBoardSpace + 16),
            child: Column(
              children: [
                if(width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                          maxLength: 50,
                        ),
                      ),

                      const SizedBox(width: 16,),

                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            prefixText: "₹ ",
                            label: Text('Amount'),
                          ),
                          maxLength: 50,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                    maxLength: 50,
                  ),

                const SizedBox(height: 16,),

                if(width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values.map(
                              (category) => DropdownMenuItem(
                            value: category,
                            child: Text(
                              category.name.toUpperCase(),
                            ),
                          ),
                        ).toList(),
                        onChanged: (value){
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),

                      const SizedBox(width: 16,),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_selectedDate == null ? "No Date Selected" : formatter.format(_selectedDate!),),
                            IconButton(
                              onPressed: _showDatePicker,
                              icon: Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            prefixText: "₹ ",
                            label: Text('Amount'),
                          ),
                          maxLength: 50,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16,),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(_selectedDate == null ? "No Date Selected" : formatter.format(_selectedDate!),),
                            IconButton(
                              onPressed: _showDatePicker,
                              icon: Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 16,),

                if(width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Add Expense"),
                      ),
                    ],
                  )
                else
                Row(
                  children: [
                    const Text("Choose Category"),
                    const Spacer(),
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values.map(
                            (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ),
                      ).toList(),
                      onChanged: (value){
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16,),

                if(width < 600)
                  Row(
                    children: [
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Add Expense"),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}