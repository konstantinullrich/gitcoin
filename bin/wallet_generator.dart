import 'package:gitcoin/gitcoin.dart';

main() {
  Wallet wallet = Wallet.fromRandom();
  wallet.saveToFile("./");
  print("Do not send the private_key file to anyone!");
}