import 'dart:io';

import 'package:crypton/crypton.dart';
import 'package:gitcoin/gitcoin.dart';

class Wallet {
  RSAPublicKey _publicKey;
  RSAPrivateKey _privateKey;

  RSAPublicKey get publicKey => _publicKey;
  RSAPrivateKey get privateKey => _privateKey;

  Wallet.fromRandom() {
    RSAKeypair keypair = RSAKeypair.fromRandom();
    this._publicKey = keypair.publicKey;
    this._privateKey = keypair.privateKey;
  }

  Wallet.fromPem(String privateKeyFilePath, String publicKeyFilePath) {
    File privateKeyFile = File(privateKeyFilePath);
    File publicKeyFile = File(publicKeyFilePath);

    if (!privateKeyFile.existsSync()) throw('\"$privateKeyFilePath\" does not exist or is not a valid path');
    if (!publicKeyFile.existsSync()) throw('\"$publicKeyFilePath\" does not exist or is not a valid path');

    this._privateKey = RSAPrivateKey.fromString(decodePEM(privateKeyFile.readAsStringSync()));
    this._publicKey = RSAPublicKey.fromString(decodePEM(publicKeyFile.readAsStringSync()));
  }

  void saveToFile(String folderPath) {
    Directory directory = Directory(folderPath);
    if (!directory.existsSync()) directory.createSync(recursive: true);

    File privateKeyFile = File('${directory.path}/private_key');
    File publicKeyFile = File('${directory.path}/public_key.pub');
    if (!privateKeyFile.existsSync()) privateKeyFile.createSync();
    if (!publicKeyFile.existsSync()) publicKeyFile.createSync();

    privateKeyFile.writeAsString(encodePrivateKeyToPem(this.privateKey));
    publicKeyFile.writeAsString(encodePublicKeyToPem(this.publicKey));
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