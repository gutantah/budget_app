import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../models/transaction_model.dart';
import '../services/addTransaction.dart';

class TransactionScreen extends StatelessWidget {
  final TransactionService transactionService;
  final VoidCallback onDataChanged;

  const TransactionScreen({
    super.key,
    required this.transactionService,
    required this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    final transactions = transactionService.transactions;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTransaction = await showDialog<TransactionModel>(
            context: context,
            builder: (_) => const AddTransaction(),
          );

          if (newTransaction != null) {
            transactionService.addTransaction(newTransaction);
            onDataChanged();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];

          return Dismissible(
            key: ValueKey(transaction.id),

            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            onDismissed: (direction) {
              transactionService.deleteTransaction(transaction.id);
              onDataChanged();
            },

            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              child: ListTile(
                title: Text(transaction.title),

                subtitle: Text(
                  "${transaction.category} • \$${transaction.amount.toStringAsFixed(2)}",
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "\$${transaction.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: transaction.isIncome ? Colors.greenAccent.shade400 : Colors.redAccent.shade400,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.edit),

                      onPressed: () async {
                        final editedTransaction =
                            await showDialog<TransactionModel>(
                          context: context,
                          builder: (_) => AddTransaction(
                            existingTransaction: transaction,
                          ),
                        );

                        if (editedTransaction != null) {
                          transactionService
                              .updateTransaction(editedTransaction);

                          onDataChanged();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}