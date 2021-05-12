import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) deleteTransaction;

  const TransactionList({
    required this.transactions,
    required this.deleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              final tx = transactions[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: FittedBox(
                        child: Text('\$${tx.amount.toStringAsFixed(2)}'),
                      ),
                    ),
                  ),
                  title: Text(
                    tx.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? TextButton.icon(
                          label: Text(
                            'Delete',
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                            ),
                          ),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () => deleteTransaction(tx.id),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () => deleteTransaction(tx.id),
                        ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
