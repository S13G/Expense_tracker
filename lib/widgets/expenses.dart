import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  // List to store registered expenses
  final List<Expense> _registeredExpenses = [
    // Example expenses, can be replaced with real data or loaded dynamically
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  // Function to open the add expense overlay
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true, // prevents the modal from reaching the camera
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  // Function to add a new expense
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  // Function to remove an expense
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    // Clear old info messages immediately after another action is performed
    ScaffoldMessenger.of(context).clearSnackBars();

    // Show an info message once removed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  // Build method to create the UI
  @override
  Widget build(BuildContext context) {
    // find out the amount of width available
    final width = MediaQuery.of(context).size.width;
    // Default content if no expenses are available
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some'),
    );

    // If there are expenses, display the ExpensesList
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    // The main scaffold that represents the entire screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          // Button to open the add expense overlay
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                // Chart to visualize expenses
                Chart(expenses: _registeredExpenses),
                // Expanded widget to allow for dynamic resizing of the ExpensesList
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                // Chart to visualize expenses
                Expanded(
                  child: Chart(expenses: _registeredExpenses),
                ),
                // Expanded widget to allow for dynamic resizing of the ExpensesList
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
