import 'dart:io';

import 'package:crypton/crypton.dart';
import 'package:gitcoin/gitcoin.dart';

class Wallet {
  ECPublicKey _publicKey;
  ECPrivateKey _privateKey;

  ECPublicKey get publicKey => _publicKey;
  ECPrivateKey get privateKey => _privateKey;

  Wallet.fromRandom() {
    ECKeypair keypair = ECKeypair.fromRandom();
    this._publicKey = keypair.publicKey;
    this._privateKey = keypair.privateKey;
  }

  Wallet.fromPem(String privateKeyFilePath, String publicKeyFilePath) {
    File privateKeyFile = File(privateKeyFilePath);
    File publicKeyFile = File(publicKeyFilePath);

    if (!privateKeyFile.existsSync()) throw('\"$privateKeyFilePath\" does not exist or is not a valid path');
    if (!publicKeyFile.existsSync()) throw('\"$publicKeyFilePath\" does not exist or is not a valid path');

    this._privateKey = ECPrivateKey.fromString(decodePEM(privateKeyFile.readAsStringSync()));
    this._publicKey = ECPublicKey.fromString(decodePEM(publicKeyFile.readAsStringSync()));
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