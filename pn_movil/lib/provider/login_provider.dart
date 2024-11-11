import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  bool isLoading = false;

  bool get isValidForm => formKey.currentState!.validate();

  Future<bool> login(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    notifyListeners();

    if (isValidForm) {
      Navigator.pushReplacementNamed(context, 'home');
      return true;
    } else {
      return false;
    }
  }
}
