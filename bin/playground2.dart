import 'package:gitcoin/gitcoin.dart';

void main() {
  StorageManager storageManager = StorageManager("./stroage/");
  print(storageManager.pendingTransactions);
}