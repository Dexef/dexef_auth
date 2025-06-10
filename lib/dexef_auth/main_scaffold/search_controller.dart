import 'package:flutter/material.dart';

class SearchControllerCustom extends ChangeNotifier {
  String _query = '';
  String get query => _query;
  int scaffoldKey = 0;
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  static bool whenTapSearch = false;

  void updateQuery(String value) {
    if (_query != value) {
      _query = value;
      notifyListeners(); // notify pages listening
    }
  }
  void refreshScaffold() {
    scaffoldKey++;
    notifyListeners();
  }

  void clear() {
    _query = '';
    notifyListeners();
  }

  void tapSearch(){
    whenTapSearch = !whenTapSearch;
    if(whenTapSearch == false){
      clear();
    }
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}