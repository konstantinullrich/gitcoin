import 'dart:io';

import 'package:gitcoin/gitcoin.dart';
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

    if (!privateKeyFile.existsSync()) throw("\"$privateKeyFilePath\" does not exist or is not a valid path");
    if (!publicKeyFile.existsSync()) throw("\"$publicKeyFilePath\" does not exist or is not a valid path");

    this._privateKey = RsaKeyHelper.parsePrivateKeyFromPem(privateKeyFile.readAsStringSync());
    this._publicKey = RsaKeyHelper.parsePublicKeyFromPem(publicKeyFile.readAsStringSync());
  }

  void saveToFile(String folderPath) {
    Directory directory = Directory(folderPath);
    if (!directory.existsSync()) throw("\"$folderPath\" does not exist or is not a valid path");
    print(directory.path);
    // File privateKeyFile = File();
    // File publicKeyFile = File();
  }

}