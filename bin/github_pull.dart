import 'dart:core';

import 'package:gitcoin/gitcoin.dart';

void main() {
  Wallet wallet1 = Wallet.fromPem('./wallet/private_key_konsti', './wallet/public_key_konsti.pub');
  Wallet wallet2 = Wallet.fromPem('./wallet/private_key_maximilian', './wallet/public_key_maximilian.pub');
  Wallet wallet3 = Wallet.fromPem('./wallet/private_key_sebastian', './wallet/public_key_sebastian.pub');
  List<Map> githubUser = [
    {'name': 'konstantinullrich', 'wallet': wallet1},
    {'name': 'Maximilian-Seitz', 'wallet': wallet2},
    {'name': 'SebastianAigner', 'wallet': wallet3}
    ];
  StorageManager storageManager = StorageManager('./storage');
  for (Map entry in githubUser) {
    Wallet wallet = entry['wallet'];
    String name = entry['name'];
    String publicKey = RsaKeyHelper.encodePublicKeyToString(wallet.publicKey);
    GithubWorker githubWorker = GithubWorker(name, publicKey, storageManager, Broadcaster([]));
    githubWorker.generateRevenue();
  }
}