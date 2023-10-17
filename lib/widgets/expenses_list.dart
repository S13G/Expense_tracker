import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    Key? key,
    required this.expenses,
    // A function to be called when an expense is removed.
    required this.onRemoveExpense,
  }) : super(key: key);

  // The list of expenses to display.
  final List<Expense> expenses;

  // A function to be called when an expense is removed.
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    // Build and create a scrollable list using ListView.builder.
    return ListView.builder(
      itemCount: expenses.length,
      // The builder callback is called for each item in the list.
      itemBuilder: (ctx, index) => Dismissible(
        // A key is needed to let Flutter identify a widget and the data in it.
        key: ValueKey(expenses[index]),
        // The background when an item is swiped for removal.
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        // Callback when an item is dismissed (removed).
        onDismissed: (direction) {
          // Call the onRemoveExpense function when an expense is dismissed.
          onRemoveExpense(expenses[index]);
        },
        child: ExpenseItem(
          expense: expenses[index],
        ),
      ),
    );
  }
}
