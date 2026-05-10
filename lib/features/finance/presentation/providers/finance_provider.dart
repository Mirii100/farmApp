import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String amount;
  final String date;
  final bool isIncome;

  Transaction({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}

class FinanceProvider with ChangeNotifier {
  final List<Transaction> _transactions = [
    Transaction(title: 'Sale: Maize 500kg', amount: 'KSh 15,000', date: 'May 8, 2026', isIncome: true),
    Transaction(title: 'M-Pesa: Fertilizer', amount: 'KSh 3,200', date: 'May 7, 2026', isIncome: false),
    Transaction(title: 'Labor: Weeding', amount: 'KSh 1,500', date: 'May 6, 2026', isIncome: false),
  ];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  String get netProfit => 'KSh 42,500'; // Still mock for now
  String get totalIncome => 'KSh 68K';
  String get totalExpenses => 'KSh 25.5K';
}
