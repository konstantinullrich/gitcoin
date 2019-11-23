import 'dart:io';
import 'dart:isolate';

import 'package:gitcoin/gitcoin.dart';

Wallet wallet = Wallet.fromRandom();
StorageManager storageManager = StorageManager("./storage/");
String githubUser = "konstantinullrich12";
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

void runGithubHandler(dynamic d) {
  String publicKey = RsaKeyHelper.encodePublicKeyToString(wallet.publicKey);
  GithubWorker githubWorker = GithubWorker(githubUser, publicKey, storageManager, broadcaster);
  while(true) {
    githubWorker.generateRevenue();
    sleep(Duration(minutes: 1));
  }
}

void runWebServer(dynamic d) {
  RestHandler restHandler = RestHandler(storageManager, webPort);
  restHandler.run();
}

void main() {
  ReceivePort receivePort= ReceivePort();
  Future<Isolate> blockchainValidator = Isolate.spawn(runBlockchainValidator, receivePort.sendPort);
  Future<Isolate> githubHandler = Isolate.spawn(runGithubHandler, receivePort.sendPort);
  Future<Isolate> webServer = Isolate.spawn(runWebServer, receivePort.sendPort);
}