import 'package:expense_tracker/models/expense.dart';  // Importing the Expense model.
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({Key? key, required this.expense}) : super(key: key);

  final Expense expense;  // The expense data to display.

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // Adding padding to the content.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Aligning content to the start of the column.
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
              // Displaying the expense title using a specific text style.
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                // Displaying the amount with 2 decimal places.
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(),
                // A row to align two child widgets horizontally with maximum space in between.
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),  // Displaying the category icon.
                    const SizedBox(
                      width: 8,
                    ),
                    Text(expense.formattedDate)  // Displaying the formatted date.
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
