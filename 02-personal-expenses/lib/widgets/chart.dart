import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<_GroupedTransaction> get _groupedTransactionValues {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final weekDay = now.subtract(
        Duration(days: 6 - index),
      );
      final totalSum = recentTransactions.where((tx) {
        return tx.date.day == weekDay.day &&
            tx.date.month == weekDay.month &&
            tx.date.year == weekDay.year;
      }).fold<double>(0, (sum, tx) => sum + tx.amount);
      return _GroupedTransaction(DateFormat.E().format(weekDay), totalSum);
    });
  }

  double get totalSpending =>
      _groupedTransactionValues.fold(0, (sum, tx) => sum + tx.amount);

  @override
  Widget build(BuildContext context) {
    final total = this.totalSpending;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _groupedTransactionValues.map((gtx) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: gtx.day,
                spendingAmount: gtx.amount,
                spendingPctOfTotal: total == 0 ? 0 : gtx.amount / total,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _GroupedTransaction {
  final String day;
  final double amount;

  _GroupedTransaction(this.day, this.amount);
}
