import 'package:flutter/material.dart';

class NewTransaction extends StatelessWidget {
  final Function(String, double) addNewTransaction;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  NewTransaction(this.addNewTransaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleController,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountController,
            ),
            TextButton(
              child: Text('Add Transaction'),
              style: TextButton.styleFrom(
                primary: Colors.purple,
              ),
              onPressed: () {
                addNewTransaction(
                  _titleController.text,
                  double.parse(_amountController.text),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
