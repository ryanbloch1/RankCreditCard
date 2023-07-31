
class CreditCard {
  String cardNumber;
  String cvv;
  String issuingCountry;
  String cardHolderName;
  String expiryDate;

  CreditCard({
    required this.cardNumber,
    required this.cvv,
    required this.issuingCountry,
    required this.cardHolderName,
    required this.expiryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "cardNumber": cardNumber,
      "cvv": cvv,
      "issuingCountry": issuingCountry,
      "cardHolderName": cardHolderName,
      "expiryDate": expiryDate,
    };
  }
  static CreditCard fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardNumber: json["cardNumber"],
      cvv: json["cvv"],
      issuingCountry: json["issuingCountry"],
      cardHolderName: json["cardHolderName"],
      expiryDate: json["expiryDate"],
    );
  }
}
