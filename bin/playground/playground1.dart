import 'dart:convert';

import 'package:gitcoin/gitcoin.dart';
import 'package:pointycastle/pointycastle.dart';

void main() {
  ECWallet ecWallet = ECWallet.fromRandom();
  var w1 = ecWallet.privateKey.d.toRadixString(16);

  ECSignature sig = ECCreateSignature("test", ecWallet.privateKey);
  var ssig = sig.r.toRadixString(16)+"|"+sig.s.toRadixString(16);
  print(validateECStringSignature("test", ssig, ecWallet.publicKey));

}