import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transaction_service.dart';

class DashboardScreen extends StatefulWidget {
  final TransactionService transactionService;

  const DashboardScreen({
    super.key,
    required this.transactionService,
    });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TimeFilter selectedFilter = TimeFilter.currentMonth;
  Color colorForCategory(String category) {
    switch (category) {
      case "necessities":
        return Colors.blue;
      case "wants":
        return Colors.orange;
      case "investments":
        return Colors.green;
      case "general":
        return Colors.grey;
      case "Income":
        return Colors.purple;
      default:
        return Colors.black;
    }
  }
  @override
  Widget build(BuildContext context) {
      final filteredTransactions = widget.transactionService.getFilteredTransactions(selectedFilter);
      final  balance = widget.transactionService.calculateBalance(filteredTransactions);
      final expense = widget.transactionService.calculateTotalExpense(filteredTransactions);
      final categoryTotals = widget.transactionService.getExpenseCategoryTotals(filteredTransactions);

      List<PieChartSectionData> piechartSelections = [];
      if(expense > 0) {
        categoryTotals.forEach((category, amount) {
          final percentage = ((amount / expense) * 100).toStringAsFixed(1);
          piechartSelections.add(
            PieChartSectionData(
              value: amount,
              title: "$percentage%",
              color: colorForCategory(category),
              radius: 50,
              titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          );
        });
      }
      //trebuie adaugat afisarea graficului
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Balance: \$ ${balance.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 28,
              fontWeight: FontWeight.bold,
              color: balance >= 0 ? Colors.black : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Text("Income: \$ ${widget.transactionService.totalIncome}",
            style: TextStyle(fontSize:18, color: Colors.green),
          ),
          Text("Expense: \$ ${widget.transactionService.totalExpense}",
            style: TextStyle(fontSize:18, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
