import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:crypton/crypton.dart';


class Transaction {
  String _fromAddress;
  String _toAddress;
  int _amount;
  int _timestamp = DateTime.now().millisecondsSinceEpoch;
  String _signature;

  String get toAddress => _toAddress;
  String get fromAddress => _fromAddress;
  int get amount => _amount;
  int get timestamp => _timestamp;

  /// Returns if the Transaction is valid
  bool get isValid {
    if (this._fromAddress == null) return true; // We assume it is a miners Reward
    if (this._fromAddress.startsWith('https://') || this._fromAddress.startsWith('http://')) return true; // We assume it is a Reward for a PR

    if (this._signature == null || this._signature.isEmpty) {
      throw('No signature in this transaction');
    }

    ECPublicKey publicKey = ECPublicKey.fromString(this._fromAddress);
    bool hasValidSignature = publicKey.verifySignature(this.toHash(), this._signature);

    return this._fromAddress != this._toAddress && !this._amount.isNegative && hasValidSignature;
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

  void signTransaction(PrivateKey privateKey) {
    this._signature = privateKey.createSignature(this.toHash());
  }

  String toHash() {
    return sha256.convert(
        utf8.encode(this.toString())
    ).toString();
  }

  String toString() {
    return this._fromAddress.toString() +
        this._toAddress.toString() +
        this._amount.toString() +
        this._timestamp.toString();
  }

  Map toMap() {
    return {
      'fromAddress': this._fromAddress,
      'toAddress': this._toAddress,
      'amount': this._amount,
      'signature': this._signature,
      'timestamp': this._timestamp
    };
  }

}