import 'dart:core';

import 'package:gitcoin/blockchain/block.dart';
import 'package:gitcoin/transaction/transaction_list.dart';
import 'package:gitcoin/utils/rsa_pem.dart';

void main() {
var kp = RsaKeyHelper.generateKeyPair();
var sk = kp.privateKey;
var publicKey = kp.publicKey;
String publicKeyString = RsaKeyHelper.encodePublicKeyToString(publicKey);
print(publicKeyString);

print("---");

TransactionList trx = TransactionList();
  Block b = Block(trx, publicKeyString);
  b.signBlock(sk);
  print(b.isValid);
  print(b.toMap());
}