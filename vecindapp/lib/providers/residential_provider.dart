import 'package:flutter/material.dart';
import 'package:vecindapp/models/residential.dart';

class ResidentialProvider extends ChangeNotifier {
  final List<Residential> _residentials = [];

  List<Residential> get residentials => _residentials;

  void addResidential(Residential res) {
    _residentials.add(res);
    notifyListeners();
  }
}
