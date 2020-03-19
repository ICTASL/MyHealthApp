import 'package:flutter/cupertino.dart';
import 'package:selftrackingapp/models/reported_case.dart';

class RegisteredCasesModel extends ChangeNotifier {
  final List<ReportedCase> _reportedCases = [];

  /// An unmodifiable view of the items in the cart.
  List<ReportedCase> get reportedCases => _reportedCases;

  void add(ReportedCase reportedCase) {
    if (!_reportedCases.contains(reportedCase)) {
      _reportedCases.insert(0, reportedCase);
      notifyListeners();
    }
  }
}
