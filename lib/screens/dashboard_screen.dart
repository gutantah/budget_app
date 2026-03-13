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
  String selectedCard = "All Cards";

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
      final filteredTransactions = widget.transactionService.getFilteredTransactions(selectedFilter, cardName: selectedCard);
      final  balance = widget.transactionService.calculateBalance(filteredTransactions);
      final expense = widget.transactionService.calculateTotalExpense(filteredTransactions);
      final categoryTotals = widget.transactionService.getExpenseCategoryTotals(filteredTransactions);

      List<String> availableCards = ['All Cards'] + widget.transactionService.getAvailableCards();
      if (!availableCards.contains(selectedCard)) {
        selectedCard = "All Cards";
      }

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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Filtru Perioadă
              DropdownButton<TimeFilter>(
                value: selectedFilter,
                items: TimeFilter.values.map((filter) {
                  return DropdownMenuItem(
                    value: filter,
                    child: Text(filter.name.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => selectedFilter = value);
                },
              ),
              DropdownButton<String>(
                value: selectedCard,
                items: availableCards.map((card) {
                  return DropdownMenuItem(
                    value: card,
                    child: Text(card),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => selectedCard = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Balance: \$ ${balance.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: balance >= 0 ? Colors.black : Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Income: \$ ${widget.transactionService.totalIncome.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, color: Colors.green)),
              Text("Expense: \$ ${widget.transactionService.totalExpense.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, color: Colors.red)),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: expense > 0 
              ? PieChart(
                  PieChartData(
                    sections: piechartSelections,
                    centerSpaceRadius: 50,
                    sectionsSpace: 2,
                  ),
                )
              : const Center(
                  child: Text(
                    "No expenses in this period",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

