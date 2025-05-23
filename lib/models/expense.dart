import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const Uuid uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { food, travel, entertainment, other, health, education, shopping }

const Map<Category, IconData> categoryIcons = <Category, IconData>{
  Category.food: Icons.fastfood,
  Category.travel: Icons.directions_bus,
  Category.entertainment: Icons.movie,
  Category.other: Icons.more_horiz,
  Category.health: Icons.local_hospital,
  Category.education: Icons.school,
  Category.shopping: Icons.shopping_cart,
};

class Expense {
  Expense({required this.title, required this.amount, required this.date, required this.category}) : id = uuid.v4();

  final String title;
  final double amount;
  final String id;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category) : expenses = allExpenses.where((expense) => expense.category == category).toList();
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for(final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}