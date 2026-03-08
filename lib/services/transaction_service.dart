import '../models/transaction_model.dart';

enum TimeFilter { currentMonth, currentQuarter, currentYear, allTime }

class TransactionService {
  final List<TransactionModel> _transactions = [];
  List<TransactionModel> get transactions => _transactions;

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
  }

  void updateTransaction(TransactionModel updatedTransaction) {
    final index = _transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
  }

  List<TransactionModel> getFilteredTransactions(TimeFilter filter){
    final now = DateTime.now();
    DateTime startDate;
    switch (filter) {
      case TimeFilter.currentMonth:
        startDate = DateTime(now.year, now.month, 1);
        break;
      case TimeFilter.currentQuarter:
        final currentQuarter = (now.month - 1) ~/ 3 + 1;
        startDate = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        break;
      case TimeFilter.currentYear:
        startDate = DateTime(now.year, 1, 1);
        break;
      case TimeFilter.allTime:
        return _transactions; 
    }
    return _transactions.where((t) => !t.date.isBefore(startDate)).toList();
  }
    double calculateTotalIncome(List<TransactionModel> transact) {
      return transact.where((t) => t.isIncome).fold(0, (sum, t) => sum + t.amount);
    }
    double calculateTotalExpense(List<TransactionModel> transact) {
      return transact.where((t) => !t.isIncome).fold(0, (sum, t) => sum + t.amount);
    }
    double calculateBalance(List<TransactionModel> transact) {
      return calculateTotalIncome(transact) - calculateTotalExpense(transact);
    }

    double get totalIncome => calculateTotalIncome(transactions);
    double get totalExpense => calculateTotalExpense(transactions);
    double get balance => calculateBalance(transactions);

    Map<String, double> getExpenseCategoryTotals(List<TransactionModel> transact) {
    final Map<String, double> totals = {};

    final expenses=transact.where((t)=>!t.isIncome); 

    for (var t in expenses) {
      if (totals.containsKey(t.category)) {
        totals[t.category] = totals[t.category]! + t.amount; 
        } else {
        totals[t.category] = t.amount;
      }
    }
    return totals;
  }
}