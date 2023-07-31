// providers/credit_card_provider.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/creditcard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditCardProvider extends ChangeNotifier {
  List<CreditCard> _creditCards = [];

  List<CreditCard> get creditCards => _creditCards;

  void addCreditCard(CreditCard creditCard) {
    _creditCards.add(creditCard);
    notifyListeners();
    saveCreditCardsToSharedPreferences();
  }
  void addAllCreditCards(List<CreditCard> creditCards) {
    _creditCards.addAll(creditCards);
    notifyListeners();
  }

  void removeCreditCard(CreditCard creditCard) {
    _creditCards.remove(creditCard);
    notifyListeners();
    saveCreditCardsToSharedPreferences();
  }

  Future<void> saveCreditCardsToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> creditCardJsonList = creditCards.map((card) => json.encode(card.toJson())).toList() as List<String>;
    prefs.setStringList('credit_cards', creditCardJsonList);
  }
}



