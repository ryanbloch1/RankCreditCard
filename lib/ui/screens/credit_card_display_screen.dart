import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../../models/creditcard.dart';
import '../../providers/credit_card_provider.dart';
import '../../utils/card_utils.dart';

class CreditCardDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final creditCardProvider = Provider.of<CreditCardProvider>(context);
    final List<CreditCard> creditCards = creditCardProvider.creditCards;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Saved Cards"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: creditCards.isNotEmpty
            ? ListView.builder(
                itemCount: creditCards.length,
                itemBuilder: (context, index) {
                  var creditCard = creditCards[index];
                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 20),
                        child: CreditCardUi(
                          topLeftColor: Colors.blueGrey,
                          cardHolderFullName: creditCard.cardHolderName,
                          cardNumber:
                              CardUtils.getCleanedNumber(creditCard.cardNumber),
                          validThru: creditCard.expiryDate,
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.topRight,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: _DeleteCardButton(
                            onPressed: () =>
                                _confirmDeleteCard(context, creditCard),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : _buildEmptyState(),
      ),
    );
  }

  void _confirmDeleteCard(BuildContext context, CreditCard card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Card'),
          content: Text('Are you sure you want to delete this card?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform the deletion of the card
                _deleteCard(context, card);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteCard(BuildContext context, CreditCard card) {
    final creditCardProvider =
        Provider.of<CreditCardProvider>(context, listen: false);
    creditCardProvider.removeCreditCard(card);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No credit cards captured yet.',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}

class _DeleteCardButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteCardButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.delete, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
