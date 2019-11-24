import 'package:gitcoin/gitcoin.dart';

bool findInBlockList(List<Block> blocklist, String query_name, String query_value) {
  for (Block blc in blocklist) {
    Map blc_map = blc.toMap();
    List<Map> transactions = blc_map['data'];
    for (Map transaction in transactions) {
      if(transaction[query_name] == query_value)
        return true;
    }
  }
  return false;
}

int getFundsOfAddress(StorageManager storageManager, String address) {
  List<Block> blocklist = storageManager.BlockchainBlocks;
  List<Map> pendingTrx = storageManager.pendingTransactions.toList();
  int balance = 0;
  for (Block blc in blocklist) {
    for (Map trx in blc.data.toList()) {
      if (trx['fromAddress'] == address) {
        balance -= trx['amount'];
      }
      if (trx['toAddress'] == address) {
        balance += trx['amount'];
      }
    }
  }
  for (Map trx in pendingTrx) {
    if (trx['fromAddress'] == address) {
      balance -= trx['amount'];
    }
    if (trx['toAddress'] == address) {
      balance += trx['amount'];
    }
  }
  return balance;
}