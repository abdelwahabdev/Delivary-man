import 'package:efood_multivendor_driver/data/model/response/language_model.dart';
import 'package:efood_multivendor_driver/util/app_constants.dart';
import 'package:flutter/material.dart';

class LanguageRepo {
  List<LanguageModel> getAllLanguages({BuildContext context}) {
    return AppConstants.languages;
  }
}
