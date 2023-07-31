import 'package:flutter/material.dart';

enum CardBrand {
  Master,
  Visa,
  Discover,
  AmericanExpress,
  Others,
  Invalid
}

class CardUtils {

  static String getCleanedNumber(String text) {
    RegExp regExp = RegExp("r[^0-9]");
    return text.replaceAll(regExp, '');
  }

  static String? validateCardNum(String? input) {
    try {
      if (input == null || input.isEmpty) {
        return "This field is required";
      }
      // Clean the input and remove any non-digit characters
      String cleanedInput = getCleanedNumber(input);

      if (cleanedInput.length < 8) {
        return "Card is invalid";
      }
      // Perform Luhn algorithm validation
      if (!isValidLuhn(cleanedInput)) {
        return "Card is invalid";
      }
      // If all checks pass, return null to indicate no validation errors
      return null;
    } on Exception catch (_) {
    }

  }

  // Function to perform Luhn algorithm validation
  static bool isValidLuhn(String input) {
    int sum = 0;
    int length = input.length;
    for (var i = 0; i < length; i++) {
      int digit = int.parse(input[length - i - 1]);
      if (i % 2 == 1) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
    }
    return sum % 10 == 0;
  }

  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    int year;
    int month;
    if (value.contains(RegExp(r'(/)'))) {
      var split = value.split(RegExp(r'(/)'));

      month = int.parse(split[0]);
      year = int.parse(split[1]);
    } else {
      month = int.parse(value.substring(0, (value.length)));
      year = -1;
    }
    if ((month < 1) || (month > 12)) {
      return 'Expiry month is invalid';
    }
    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      return 'Expiry year is invalid';
    }
    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }
    return null;
  }

  static bool hasDateExpired(int month, int year) {
    return isNotExpired(year, month);
  }

  static bool isNotExpired(int year, int month) {
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  static List<int> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    return fourDigitsYear < now.year;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static CardBrand getCardTypeFrmNumber(String input) {
    CardBrand cardType;
    if (input.startsWith(RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = CardBrand.Master;
    } else if (input.startsWith(RegExp(r'[4]'))) {
      cardType = CardBrand.Visa;
    }  else if (input.startsWith(RegExp(r'((34)|(37))'))) {
      cardType = CardBrand.AmericanExpress;
    } else if (input.startsWith(RegExp('^6(?:011|5[0-9]{2})'))) {
      cardType = CardBrand.Discover;
    }  else if (input.length <= 8) {
      cardType = CardBrand.Others;
    } else {
      cardType = CardBrand.Invalid;
    }
    return cardType;
  }

  static Widget? getCardIcon(CardBrand? cardType) {
    String img = "";
    Icon? icon;
    switch (cardType) {
      case CardBrand.Master:
        img = 'mastercard.png';
        break;
      case CardBrand.Visa:
        img = 'visa.png';
        break;
      case CardBrand.AmericanExpress:
        img = 'amex.png';
        break;
      case CardBrand.Discover:
        img = 'discover.png';
        break;
      case CardBrand.Others:
        icon = const Icon(
          Icons.credit_card,
          size: 24.0,
          color: Color(0xFFB8B5C3),
        );
        break;
      default:
        icon = const Icon(
          Icons.warning,
          size: 24.0,
          color: Color(0xFFB8B5C3),
        );
        break;
    }
    Widget? widget;
    if (img.isNotEmpty) {
      widget = Image.asset(
        'assets/images/$img',
        width: 40.0,
      );
    } else {
      widget = icon;
    }
    return widget;
  }
}
