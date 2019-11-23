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
      print("Start mining a Block");
      final stopwatch = Stopwatch()..start();
      blockchain.createBlock();
      print('The mining Process was completed in ${stopwatch.elapsed}');
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