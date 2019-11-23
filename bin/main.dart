import 'dart:io';
import 'dart:isolate';

import 'package:gitcoin/gitcoin.dart';

void runBlockchainValidator(dynamic d) {
  StorageManager storageManager = StorageManager("./storage/");
  Wallet wallet = Wallet.fromRandom();
  Blockchain blockchain = Blockchain(wallet, storageManager);
  storageManager.storeBlockchain(blockchain);
  while(true) {
    print(storageManager.pendingTransactions.length);
    if (storageManager.pendingTransactions.length > 2) {
      blockchain.createBlock();
    } else {
      sleep(Duration(seconds: 10));
    }
  }
}

void main() {
  ReceivePort receivePort= ReceivePort();
  var t = Isolate.spawn(runBlockchainValidator, receivePort.sendPort);
}