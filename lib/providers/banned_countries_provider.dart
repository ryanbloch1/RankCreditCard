import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannedCountriesProvider with ChangeNotifier {
  List<String> _bannedCountries = [];

  List<String> get bannedCountries => _bannedCountries;

  void addBannedCountry(String country) {
    _bannedCountries.add(country);
    notifyListeners();
    saveBannedCountries();
  }

  void removeBannedCountry(String country) {
    _bannedCountries.remove(country);
    notifyListeners();
    saveBannedCountries();
  }

  bool isCountryBanned(String country) {
    return _bannedCountries.contains(country);
  }

  void addBannedCountries(List<String> bannedCountries) {
    _bannedCountries.addAll(bannedCountries);
    notifyListeners();
  }

  Future<void> saveBannedCountries() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('banned_countries', _bannedCountries);
  }

}

