import 'dart:convert';

import 'package:credit_card_validation/ui/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:credit_card_validation/providers/credit_card_provider.dart';
import 'package:credit_card_validation/providers/banned_countries_provider.dart';
import 'package:credit_card_validation/ui/screens/manage_banned_countries_screen.dart';
import 'models/creditcard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadSavedData();
}

Future<void> loadSavedData() async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? savedCreditCards = prefs.getStringList('credit_cards');
  final List<String>? bannedCountries = prefs.getStringList('banned_countries');

  final creditCardProvider = CreditCardProvider();
  if (savedCreditCards != null) {
    try {
      List<CreditCard> creditCards = savedCreditCards
          .map((creditCardJson) =>
              CreditCard.fromJson(jsonDecode(creditCardJson)))
          .toList();

      creditCardProvider.addAllCreditCards(creditCards);
    } catch (e) {
      print("Error loading saved credit cards: $e");
    }
  } else {
    print("No cards");
  }

  final bannedCountriesProvider = BannedCountriesProvider();
  if (bannedCountries != null) {
    bannedCountriesProvider.addBannedCountries(bannedCountries);
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: creditCardProvider),
        ChangeNotifierProvider.value(value: bannedCountriesProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardSafeguard',
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(top: 30, left: 15, right: 15),
            children: [
              ListTile(
                title: Text('Main Menu'),
              ),
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Use the context obtained from the Builder
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageBannedCountriesScreen(),
                      ),
                    );
                  },
                  child: Text('Manage Banned Countries'),
                ),
              ),
            ],
          ),
        ),
        body: LandingPage(),
      ),
    );
  }
}
