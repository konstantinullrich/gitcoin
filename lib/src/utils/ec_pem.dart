import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';

AsymmetricKeyPair<PublicKey, PrivateKey> secp256k1KeyPair() {
  var keyParams = ECKeyGeneratorParameters(ECCurve_secp256k1());

  var random = FortunaRandom();
  random.seed(KeyParameter(_seed()));

  var generator = ECKeyGenerator();
  generator.init(ParametersWithRandom(keyParams, random));

  return generator.generateKeyPair();
}

Uint8List _seed() {
  var random = Random.secure();
  var seed = List<int>.generate(32, (_) => random.nextInt(256));
  return Uint8List.fromList(seed);
}

ECSignature ECCreateSignature(String message, ECPrivateKey privateKey) {
  AsymmetricKeyParameter<ECPrivateKey> privateKeyParams = PrivateKeyParameter(privateKey);
  Signer s = ECDSASigner();
  s.init(true, privateKeyParams);
  return s.generateSignature(utf8.encode(message));
}

bool validateECStringSignature(String message, String signature, ECPublicKey publicKey) {
  BigInt r = BigInt.parse(signature.split("|")[0], radix: 16);
  BigInt s = BigInt.parse(signature.split("|")[1], radix: 16);
  Signer signer = Signer('SHA-256/ECDSA');
  AsymmetricKeyParameter<ECPublicKey> publicKeyParams = PublicKeyParameter(publicKey);
  ECSignature sig = ECSignature(r, s);
  signer.init(false, publicKeyParams);
  return signer.verifySignature(utf8.encode(message), sig);
}