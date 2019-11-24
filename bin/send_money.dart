import 'dart:io';

import 'package:gitcoin/gitcoin.dart';

void main() {
  StorageManager storageManager = StorageManager('./storage');
  Wallet wallet = Wallet.fromPem('./wallet/private_key', './wallet/public_key.pub');
  String myAddress = RsaKeyHelper.encodePublicKeyToString(wallet.publicKey);
  int yourCurrentFund = getFundsOfAddress(storageManager, myAddress);
  int spending = 0;


  print('Hello fellow Human');
  print('Your balance: ${yourCurrentFund}G');
  print('---------------------------------');
  print('How much money do you want to spend? ');
  var input = stdin.readLineSync();
  spending = int.parse(input);
  while (yourCurrentFund < spending) {
    print('You can\'t spend more than you have!');
    input = stdin.readLineSync();
    spending = int.parse(input);
  }
  print('Where do you want to send your money? ');
  var toAddress = stdin.readLineSync();

  Transaction trx = Transaction(myAddress, toAddress, spending);
  trx.signTransaction(wallet.privateKey);

  storageManager.storePendingTransaction(trx);
  // ToDo: Broadcast to the Network
  print('You successfly transferd Money');

}