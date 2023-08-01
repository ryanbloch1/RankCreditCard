# Credit Card Validation App

The Credit Card Validation app is designed to allow admins to submit credit card numbers for validation. This app provides a simple and secure way to verify the authenticity and correctness of credit card details.

## Features

- Admins can input credit card numbers for validation.
- The app performs validation checks to ensure the accuracy of the credit card information.
- Duplicate credit card entries are prevented to maintain data integrity.
- The app supports scanning of physical credit cards for quick input.

## Getting Started

To get started with Flutter development and run this app, follow the steps below:

1. Install Flutter by following the [online documentation](https://docs.flutter.dev/get-started/install).

2. Clone this repository and navigate to the project directory.

3. Run `flutter pub get` to fetch the app's dependencies.

4. Connect a physical device or start an emulator.

5. Run `flutter run` to launch the app on your device/emulator.

## Usage

1. Upon launching the app, you'll be presented with the main screen.

2. Click on "Add New Card" to submit a credit card for validation.

3. Enter the credit card details, including the card number, cardholder name, and expiry date.

4. Click on the "Submit" button to validate and save the credit card information.

5. To view previously saved credit cards, click on "View Saved Cards."

## Dependencies

This app uses the following dependencies:

- `provider`: A state management solution for Flutter applications.
- `shared_preferences`: For persistent storage of banned countries and credit cards.
- `u_credit_card`: A custom Flutter package for displaying credit card details.
- `credit_card_scanner`: A package that enables scanning of credit cards for input.

## Additional Resources

For more information about Flutter development, including tutorials, samples, and a full API reference, check out the [online documentation](https://docs.flutter.dev/).




