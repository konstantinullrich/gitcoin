import 'dart:convert';
import 'dart:io';

import 'package:gitcoin/gitcoin.dart';
import 'package:gitcoin/src/utils/ec_pem.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:pointycastle/pointycastle.dart';

class Wallet {
  RSAPublicKey _publicKey;
  RSAPrivateKey _privateKey;

  RSAPublicKey get publicKey => _publicKey;
  RSAPrivateKey get privateKey => _privateKey;

  Wallet.fromRandom() {
    AsymmetricKeyPair<PublicKey, PrivateKey> keyPair = RsaKeyHelper.generateKeyPair();
    this._publicKey = keyPair.publicKey;
    this._privateKey = keyPair.privateKey;
  }

  Wallet.fromPem(String privateKeyFilePath, String publicKeyFilePath) {
    File privateKeyFile = File(privateKeyFilePath);
    File publicKeyFile = File(publicKeyFilePath);


    // if (!privateKeyFile.existsSync() || !publicKeyFile.existsSync()){
    //   Wallet.fromRandom();
    //   return;
    // }
    if (!privateKeyFile.existsSync()) throw('\"$privateKeyFilePath\" does not exist or is not a valid path');
    if (!publicKeyFile.existsSync()) throw('\"$publicKeyFilePath\" does not exist or is not a valid path');

    this._privateKey = RsaKeyHelper.parsePrivateKeyFromPem(privateKeyFile.readAsStringSync());
    this._publicKey = RsaKeyHelper.parsePublicKeyFromPem(publicKeyFile.readAsStringSync());
  }

  void saveToFile(String folderPath) {
    Directory directory = Directory(folderPath);
    if (!directory.existsSync()) directory.createSync(recursive: true);

    File privateKeyFile = File('${directory.path}/private_key');
    File publicKeyFile = File('${directory.path}/public_key.pub');
    if (!privateKeyFile.existsSync()) privateKeyFile.createSync();
    if (!publicKeyFile.existsSync()) publicKeyFile.createSync();

    privateKeyFile.writeAsString(RsaKeyHelper.encodePrivateKeyToPem(this.privateKey));
    publicKeyFile.writeAsString(RsaKeyHelper.encodePublicKeyToPem(this.publicKey));
  }

}

class ECWallet {
  ECPrivateKey _privateKey;
  ECPublicKey _publicKey;

  ECPrivateKey get privateKey => _privateKey;
  ECPublicKey get publicKey => _publicKey;
  String get address => base64Encode(_publicKey.Q.getEncoded());
  String get privateKeyAsString => _privateKey.d.toRadixString(16);

  ECWallet(String privateKey) {
    ECCurve_secp256k1 secp256k1 = ECCurve_secp256k1();
    this._privateKey = ECPrivateKey(BigInt.parse(privateKey, radix: 16), secp256k1);
    ECPoint Q = secp256k1.G * this._privateKey.d;
    this._publicKey = ECPublicKey(Q, ECCurve_secp256k1());
  }

  ECWallet.fromRandom(){
    AsymmetricKeyPair<PublicKey, PrivateKey> keyPair = secp256k1KeyPair();
    this._publicKey = keyPair.publicKey;
    this._privateKey = keyPair.privateKey;
  }

  String toString() => jsonEncode(this.toMap());

  Map<String, String> toMap() => {
    "privateKey": privateKeyAsString,
    "publicKey": address
  };
}