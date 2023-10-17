import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // Controllers for handling user input
  final _titledController = TextEditingController();
  final _amountController = TextEditingController();

  // Variables to store user-selected data
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  // Method to show a date picker dialog
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime.now(),
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      // ios alert dialog styling
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amount, date, and category were entered',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } else {
      // Show error message on android
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amount, date, and category were entered',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  // Method to submit expense data
  void _submitExpenseData() {
    // Parse entered amount
    final enteredAmount = double.tryParse(_amountController.text);

    // Check for invalid inputs
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titledController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }

    // Call the callback to add the expense
    widget.onAddExpense(Expense(
        title: _titledController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));

    // Close the current screen
    Navigator.pop(context);
  }

  // Dispose of controllers to free resources
  @override
  void dispose() {
    _titledController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // adding a scroll feature because of landscape mode so as to reach contents
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    // Mediaquery can be used instead of layoutbuilder
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;

      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titledController,
                          maxLength: 50,
                          decoration:
                              const InputDecoration(label: Text('Title')),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                            prefixText: '\$ ',
                          ),
                        ),
                      )
                    ],
                  )
                else
                  // Title input field
                  TextField(
                    controller: _titledController,
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('Title')),
                  ),
                // Amount and Date input fields
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase())),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Display selected date or show a button to pick one
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                    children: [
                      // Amount input field
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                            prefixText: '\$ ',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Date input field
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Display selected date or show a button to pick one
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    children: [
                      const Spacer(),
                      // Cancel button
                      TextButton(
                        onPressed: () {
                          // Removes overlay from screen
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      // Save Expense button
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      )
                    ],
                  )
                else
                  // Category selection and buttons
                  Row(
                    children: [
                      // Dropdown for selecting expense category
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase())),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      // Spacer to push the following buttons to the right
                      const Spacer(),
                      // Cancel button
                      TextButton(
                        onPressed: () {
                          // Removes overlay from screen
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      // Save Expense button
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text('Save Expense'),
                      )
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
