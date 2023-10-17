import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:uuid/uuid.dart'; // For generating unique IDs

// Create a UUID generator
const uuid = Uuid();

// Formatter for date display
final formatter = DateFormat.yMd();

// Define a set of allowed expense categories
enum Category { food, travel, leisure, work }

// Icons corresponding to each category
const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};

// Class representing an expense
class Expense {
  // Constructor for creating an Expense instance
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4(); // Automatically generate a unique ID

  // Properties of an Expense
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  // Getter method to format the date
  String get formattedDate {
    return formatter.format(date);
  }
}

// Class representing a bucket of expenses for a specific category
class ExpenseBucket {
  // Constructor for creating an ExpenseBucket instance
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  // Additional constructor to filter expenses for a specific category
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  // Properties of an ExpenseBucket
  final Category category;
  final List<Expense> expenses;

  // Method to calculate the total expenses in the bucket
  double get totalExpenses {
    double sum = 0;

    // Iterate through expenses and accumulate the total amount
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
