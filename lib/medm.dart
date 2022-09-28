import 'package:flutter/cupertino.dart';
import 'package:flutter_web3/flutter_web3.dart';

class meta extends ChangeNotifier {
  static const operationcain = 2;
  String add = "";
  int currrentcain = -1;
  bool get isEnabled => ethereum != null;
  bool get isincain => currrentcain == operationcain;
  bool get isconnect => isEnabled && add.isNotEmpty;

  Future<void> connect() async {
    if (isEnabled) {
      final acc = await ethereum!.requestAccount();
      if (acc.isNotEmpty) {
        add = acc.first;
      }
      currrentcain = await ethereum!.getChainId();
      notifyListeners();
    }
  }

  clear() {
    add = '';
    currrentcain = -1;
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });
      ethereum!.onChainChanged((chainId) {
        clear();
      });
    }
  }
}
