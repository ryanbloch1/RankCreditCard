import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/banned_countries_provider.dart';
import '../../models/countries.dart';
// Import the countries.dart file

class ManageBannedCountriesScreen extends StatefulWidget {
  @override
  _ManageBannedCountriesScreenState createState() =>
      _ManageBannedCountriesScreenState();
}

class _ManageBannedCountriesScreenState
    extends State<ManageBannedCountriesScreen> {
  @override
  Widget build(BuildContext context) {
    BannedCountriesProvider bannedCountriesProvider =
        Provider.of<BannedCountriesProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Countries You Want to Ban', // Add the title here
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child:ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              String country = countries[index];
              bool isBanned = bannedCountriesProvider.isCountryBanned(country);

              return CheckboxListTile(
                value: isBanned,
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      if (value) {
                        bannedCountriesProvider.addBannedCountry(country);
                      } else {
                        bannedCountriesProvider.removeBannedCountry(country);
                      }
                    });
                  }
                },
                title: Text(country),
              );
            },
          ), )
        ]));
  }
}
