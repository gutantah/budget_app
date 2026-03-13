import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'transaction_service.dart';
import 'dart:math';

class AddTransaction extends StatefulWidget {
  final TransactionModel? existingTransaction;
  final TransactionService transactionService;

  const AddTransaction({
    super.key, 
    this.existingTransaction, 
    required this.transactionService
  });

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  DateTime selectedDate = DateTime.now();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  late String selectedCategory;
  late String selectedCard;
  bool isIncome = false;

  @override
  void initState() {
    super.initState();

    selectedCategory = widget.transactionService.categories.first;
    selectedCard = widget.transactionService.cards.first;

    if (widget.existingTransaction != null) {
      final t = widget.existingTransaction!;
      titleController.text = t.title;
      amountController.text = t.amount.toString();
      isIncome = t.isIncome;
      selectedDate = t.date;

      if (widget.transactionService.categories.contains(t.category)) {
        selectedCategory = t.category;
      }
      if (widget.transactionService.cards.contains(t.cardName)) {
        selectedCard = t.cardName;
      }
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    super.dispose();
  }

  Future<void> _showAddNewDialog(String title, bool isCategory) async {
    final TextEditingController newOptionController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add $title"),
          content: TextField(
            controller: newOptionController,
            decoration: InputDecoration(hintText: "Name $title"),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newValue = newOptionController.text.trim();
                if (newValue.isNotEmpty) {
                  setState(() {
                    if (isCategory) {
                      widget.transactionService.addCategory(newValue);
                      selectedCategory = newValue;
                    } else {
                      widget.transactionService.addCard(newValue);
                      selectedCard = newValue;
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void submitTransaction() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text);

    // Basic validation
    if (title.isEmpty || amount == null || amount <= 0) {
      return;
    }

    final transaction = TransactionModel(
      id: widget.existingTransaction?.id ?? Random().nextInt(1000000).toString(),
      title: title,
      amount: amount,
      category: selectedCategory,
      date: selectedDate,
      isIncome: isIncome,
      cardName: selectedCard,
    );

    Navigator.pop(context, transaction);
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingTransaction != null ? "Edit Transaction" : "Add Transaction"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title input
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Amount input
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Category dropdown
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: widget.transactionService.categories.map(
                      (category) => DropdownMenuItem(value: category, child: Text(category)),
                    ).toList(),
                    onChanged: (value) => setState(() => selectedCategory = value!),
                    decoration: const InputDecoration(
                      labelText: "Category", 
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: () => _showAddNewDialog("New Category", true),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Card dropdown
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCard,
                    items: widget.transactionService.cards.map(
                      (card) => DropdownMenuItem(value: card, child: Text(card)),
                    ).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCard = value;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: "Account / Card", 
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue),
                  onPressed: () => _showAddNewDialog("New Card", false),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Income/Expense switch
            SwitchListTile(
              title: Text(isIncome ? "Income" : "Expense"),
              value: isIncome,
              onChanged: (value) {
                setState(() {
                  isIncome = value;
                });
              },
            ),

            // Date picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: const TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: pickDate, 
                  child: const Text("Choose Date")
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: submitTransaction, 
          child: Text(widget.existingTransaction != null ? "Update" : "Add")
        ),
      ],
    );
  }
}