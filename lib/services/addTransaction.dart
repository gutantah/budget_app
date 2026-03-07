import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'dart:math';

const List<String> categories = [
  "necessities",
  "wants",
  "investments",
  "general",
  "Income",
];

class AddTransaction extends StatefulWidget {
  final TransactionModel? existingTransaction;

  const AddTransaction({super.key, this.existingTransaction});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  String selectedCategory = categories.first;
  bool isIncome = false;

  @override
  void initState(){
    super.initState();
    if(widget.existingTransaction != null){
      final t = widget.existingTransaction!;
      titleController.text = t.title;
      amountController.text = t.amount.toString();
      selectedCategory = t.category;
      isIncome = t.isIncome;
    }
  }

  void dispose() {
    amountController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void submitTransaction() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text);

    // Basic validation
    if (title.isEmpty || amount == null || amount <= 0) {
      return;
    }

    final transaction = TransactionModel(
      id: Random().nextInt(1000000).toString(),
      title: title,
      amount: amount,
      category: selectedCategory,
      date: DateTime.now(),
      isIncome: isIncome,
    );

    Navigator.pop(context, transaction);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Transaction"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: "Amount",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: selectedCategory,
            items: categories
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedCategory = value;
                });
              }
            },
            decoration: const InputDecoration(
              labelText: "Category",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 10),

          SwitchListTile(
            title: Text(isIncome ? "Income" : "Expense"),
            value: isIncome,
            onChanged: (value) {
              setState(() {
                isIncome = value;
                
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: submitTransaction,
          child: const Text("Add"),
        ),
      ],
    );
  }
}