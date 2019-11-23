import 'dart:io';
import 'dart:isolate';

import 'package:gitcoin/gitcoin.dart';

Wallet wallet = Wallet.fromRandom();
StorageManager storageManager = StorageManager("./storage/");
String githubUser = "konstantinullrich";
int webPort = 3000;
Broadcaster broadcaster = Broadcaster([]);

void runBlockchainValidator(dynamic d) {
  Blockchain blockchain = Blockchain(wallet, storageManager, broadcaster: broadcaster);
  storageManager.storeBlockchain(blockchain);
  while(true) {
    if (storageManager.pendingTransactions.length > 2) {
      blockchain.createBlock();
    } else {
      sleep(Duration(seconds: 10));
    }
  }
}

void runWebServer(dynamic d) {
  RestHandler restHandler = RestHandler(storageManager, webPort);
  restHandler.run();
}

void main() {
  ReceivePort receivePort= ReceivePort();
  Future<Isolate> blockchainValidator = Isolate.spawn(runBlockchainValidator, receivePort.sendPort);
  Future<Isolate> webServer = Isolate.spawn(runWebServer, receivePort.sendPort);
}