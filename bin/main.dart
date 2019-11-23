import 'dart:io';
import 'dart:isolate';

import 'package:gitcoin/gitcoin.dart';

void runBlockchainValidator(dynamic d) {
  StorageManager storageManager = StorageManager("./stroage/");
  Wallet wallet = Wallet.fromRandom();
  Blockchain blockchain = Blockchain(wallet, storageManager);
  while(true) {
    if (storageManager.pendingTransactions.length > 5) {
      blockchain.createBlock();
    } else {
      sleep(Duration(seconds: 10));
    }
  }
}

void main() {
  ReceivePort receivePort= ReceivePort();
  Isolate.spawn(runBlockchainValidator, receivePort.sendPort);
}