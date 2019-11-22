import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';


class Transaction {
  String _fromAddress;
  String _toAddress;
  double _amount;
  int _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _signature;

  String get toAddress => _toAddress;
  String get fromAddress => _fromAddress;
  double get amount => _amount;
  int get timestamp => _timestamp;

  /// Returns if the Transaction is valid
  bool get isValid {
    if (this._fromAddress == null) return true;

    if (this._signature == null || this._signature.isEmpty) {
      throw('No signature in this transaction');
    }

    EOSPublicKey publicKey = EOSPublicKey.fromString(this._fromAddress);
    return (this._fromAddress == this._fromAddress) &&
        !this._amount.isNegative &&
        EOSSignature.fromString(this._signature)
            .verify(this.toHash(), publicKey);
  }

  Transaction(this._fromAddress, this._toAddress, this._amount);
  Transaction.fromMap(Map<String, dynamic> unresolvedTransaction) {
    if (
    unresolvedTransaction.containsKey('fromAddress') &&
        unresolvedTransaction.containsKey('toAddress') &&
        unresolvedTransaction.containsKey('amount') &&
        unresolvedTransaction.containsKey('signature') &&
        unresolvedTransaction.containsKey('timestamp')
    ) {
      this._fromAddress = unresolvedTransaction['fromAddress'];
      if (this._fromAddress == 'null') {
        this._fromAddress = null;
      }
      this._toAddress = unresolvedTransaction['toAddress'];
      if (this._toAddress == 'null') {
        this._toAddress = null;
      }
      this._amount = unresolvedTransaction['amount'];
      this._signature = unresolvedTransaction['signature'];
      this._timestamp = unresolvedTransaction['timestamp'];
    } else {
      throw('Some Parameters are missing!');
    }
  }

  void signTransaction(EOSPrivateKey privateKey) {
    if (privateKey.toEOSPublicKey().toString() != this._fromAddress) {
      throw('You cannot sign transactions for other wallets!');
    }

    String hash = this.toHash();
    this._signature = privateKey.signString(hash).toString();
  }

  String toHash() {
    return sha256.convert(
        utf8.encode(this.toString())
    ).toString();
  }

  String toString() {
    return this._fromAddress +
        this._toAddress +
        this._amount.toString() +
        this._timestamp.toString();
  }

  Map toMap() {
    return {
      "fromAddress": this._fromAddress,
      "toAddress": this._toAddress,
      "amount": this._amount,
      "signature": this._signature,
      "timestamp": this._timestamp
    };
  }

}