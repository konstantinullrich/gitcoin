import 'package:gitcoin/gitcoin.dart';

class TransactionList {
  List<Transaction> _trx = [];

  TransactionList();

  TransactionList.fromList(List unresolvedTrxList) {
    for (Map trx in unresolvedTrxList) {
      _trx.add(Transaction.fromMap(trx));
    }
  }

  int get length => _trx.length;

  void add(Transaction trx) => this._trx.add(trx);

  List<Transaction> get invalidTransactions {
    List<Transaction> results = [];
    for (Transaction trx in this._trx) {
      if (!trx.isValid) results.add(trx);
    }
    return results;
  }
  
  bool get isValid {
    return (invalidTransactions.length == 0);
  }
  
  List<Map> toList() {
    List<Map> result = [];
    for (Transaction trx in this._trx) {
      result.add(trx.toMap());
    }
    return result;
  }
  
  String toString() {
    String result = "";
    for (Transaction trx in this._trx) {
      result += trx.toString();
    }
    return result;
  }
}