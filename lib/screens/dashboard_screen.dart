import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class DashboardScreen extends StatelessWidget {
  final TransactionService transactionService;

  const DashboardScreen({
    super.key,
    required this.transactionService,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Balance: \n\$ ${transactionService.balance.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 20),
          Text("Income ${transactionService.totalIncome}"),
          Text("Expense ${transactionService.totalExpense}"),
        ],
      ),
    );
  }
}
