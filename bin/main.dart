import 'dart:io';
import 'dart:isolate';

import 'package:gitcoin/gitcoin.dart';

Wallet wallet = Wallet.fromRandom();
StorageManager storageManager = StorageManager("./storage/");
String githubUser = "konstantinullrich12";

void runBlockchainValidator(dynamic d) {
  Blockchain blockchain = Blockchain(wallet, storageManager);
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
  GithubWorker githubWorker = GithubWorker(githubUser, publicKey, storageManager);
  while(true) {
    githubWorker.generateRevenue();
    sleep(Duration(minutes: 1));
  }
}

void main() {
  ReceivePort receivePort= ReceivePort();
  Future<Isolate> blockchainValidator = Isolate.spawn(runBlockchainValidator, receivePort.sendPort);
  Future<Isolate> githubHandler = Isolate.spawn(runGithubHandler, receivePort.sendPort);
}