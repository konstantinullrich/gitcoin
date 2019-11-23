import 'dart:core';

import 'package:gitcoin/gitcoin.dart';
import 'package:gitcoin/src/networking/rest_handler.dart';

void main() {
  Wallet wallet = Wallet.fromRandom();
  String publicKey = RsaKeyHelper.encodePublicKeyToString(wallet.publicKey);
  Transaction trx = Transaction(publicKey, "test", 1);
  trx.signTransaction(wallet.privateKey);

  Broadcaster broadcaster = Broadcaster(["http://192.168.43.43:8888"]);
  broadcaster.broadcast("/transaction", trx.toMap());
  StorageManager storageManager = StorageManager("./storage");
  RestHandler restHandler = RestHandler(storageManager, 3000);
  restHandler.run();
}