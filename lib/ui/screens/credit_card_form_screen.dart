import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:u_credit_card/u_credit_card.dart';
import '../../models/creditcard.dart';
import '../../providers/banned_countries_provider.dart';
import '../../providers/credit_card_provider.dart';
import '../../utils/card_utils.dart';
import '../../models/countries.dart';
import 'credit_card_display_screen.dart';

class CreditCardFormScreen extends StatefulWidget {
  @override
  _CreditCardFormScreenState createState() => _CreditCardFormScreenState();
}

class _CreditCardFormScreenState extends State<CreditCardFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String selectedCountry = "";

  String cardNumber = '';
  String cvv = '';
  String issuingCountry = '';
  String cardHolderName = '';
  String expiryDate = '';

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  CardBrand cardBrand = CardBrand.Invalid;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(() {
      getCardTypeFromNumber();
    });
    _cardNumberController.text = '';
    _cvvController.text = '';
    _cardHolderNameController.text = '';
    _expiryDateController.text = '';
  }

  void scanCard() async {
    var cardDetails = await CardScanner.scanCard(
      scanOptions: CardScanOptions(
        scanExpiryDate: true,
        scanCardHolderName: true,
      ),
    );
    if (cardDetails != null) {
      setState(() {
        cardNumber = cardDetails.cardNumber;
        cardHolderName = cardDetails.cardHolderName;
        expiryDate = cardDetails.expiryDate;

        var formattedCardNumber = CardNumberInputFormatter()
            .formatEditUpdate(TextEditingValue(),
                TextEditingValue(text: cardDetails.cardNumber))
            .text;

        _cardNumberController.text = formattedCardNumber;
        _cardNumberController.selection = TextSelection.fromPosition(
          TextPosition(offset: formattedCardNumber.length),
        );

        _cardHolderNameController.text = cardDetails.cardHolderName;

        var formattedExpiryDate = CardMonthInputFormatter()
            .formatEditUpdate(TextEditingValue(),
                TextEditingValue(text: cardDetails.expiryDate))
            .text;

        _expiryDateController.text = formattedExpiryDate;
        _expiryDateController.selection = TextSelection.fromPosition(
          TextPosition(offset: formattedExpiryDate.length),
        );
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      CreditCard creditCard = CreditCard(
        cardNumber: cardNumber,
        cvv: cvv,
        issuingCountry: selectedCountry,
        cardHolderName: cardHolderName,
        expiryDate: expiryDate,
      );

      if (!isDuplicateCard(creditCard, context)) {
        Provider.of<CreditCardProvider>(context, listen: false)
            .addCreditCard(creditCard);
        _cardNumberController.clear();
        _cvvController.clear();
        _cardHolderNameController.clear();
        _expiryDateController.clear();

        selectedCountry = "";
        cardNumber = '';
        cvv = "";
        issuingCountry = '';
        cardHolderName = '';
        expiryDate = '';

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreditCardDisplayScreen()),
        );
      } else {
        //show dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Duplicate Card'),
              content: Text('This card has already been captured.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Add a new card"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 15),
                child: CreditCardUi(
                  topLeftColor: Colors.blueGrey,
                  cardHolderFullName: cardHolderName,
                  cardNumber: CardUtils.getCleanedNumber(cardNumber),
                  validThru: expiryDate,
                ),
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle the scan card action here
                        // You can implement the logic for scanning the card
                        scanCard();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        backgroundColor: Theme.of(context).primaryColor,
                        side: BorderSide(color: Colors.blueGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text('Scan Card',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _cardNumberController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                        CardNumberInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        labelStyle: TextStyle(color: Colors.black),
                        suffix: CardUtils.getCardIcon(cardBrand),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: CardUtils.validateCardNum,
                      onChanged: (value) {
                        setState(() {
                          cardNumber = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _cardHolderNameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Card Holder Name',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          cardHolderName = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Consumer<BannedCountriesProvider>(
                      builder: (context, bannedCountriesProvider, _) {
                        List<String> availableCountries = countries
                            .where((country) => !bannedCountriesProvider
                                .isCountryBanned(country))
                            .toList();

                        return DropdownButtonFormField<String>(
                          value:
                              selectedCountry.isEmpty ? null : selectedCountry,
                          items: [
                            ...availableCountries.map((String country) {
                              return DropdownMenuItem<String>(
                                value: country,
                                child: Text(country),
                              );
                            }).toList(),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Issuing Country',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCountry = newValue ?? '';
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cvvController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: 'CVV',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: CardUtils.validateCVV,
                            onChanged: (value) {
                              setState(() {
                                cvv = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _expiryDateController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardMonthInputFormatter(),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Expiry Date',
                              labelStyle: TextStyle(color: Colors.black),
                              // Change the label text color
                              hintText: 'MM/YY',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.blueGrey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: CardUtils.validateDate,
                            onChanged: (value) {
                              setState(() {
                                expiryDate = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor: Theme.of(context).primaryColor,
                              side: BorderSide(color: Colors.blueGrey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text('Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreditCardDisplayScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(15),
                              backgroundColor: Theme.of(context).primaryColor,
                              side: BorderSide(color: Colors.blueGrey),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text('View Your Cards',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getCardTypeFromNumber() {
    if (_cardNumberController.text.length <= 6) {
      String input = CardUtils.getCleanedNumber(_cardNumberController.text);
      CardBrand type = CardUtils.getCardTypeFrmNumber(input) as CardBrand;
      if (type != cardBrand) {
        setState(() {
          cardBrand = type;
        });
      }
    }
  }
}

bool isDuplicateCard(CreditCard newCard, BuildContext context) {
  List<CreditCard> savedCards =
      Provider.of<CreditCardProvider>(context, listen: false).creditCards;

  for (CreditCard card in savedCards) {
    if (card.cardNumber == newCard.cardNumber) {
      return true;
    }
  }
  return false;
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  "); // double space
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.toString().length,
      ),
    );
  }
}
