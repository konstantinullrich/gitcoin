import 'package:crypton/crypton.dart';

String decodePEM(String pem) {
  List<String> startsWith = [
    '-----BEGIN PUBLIC KEY-----',
    '-----BEGIN PRIVATE KEY-----',
    '-----BEGIN OPENSSH PRIVATE KEY-----',
    '-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n',
    '-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n',
  ];
  List<String> endsWith = [
    '-----END PUBLIC KEY-----',
    '-----END PRIVATE KEY-----',
    '-----END OPENSSH PRIVATE KEY-----',
    '-----END PGP PUBLIC KEY BLOCK-----',
    '-----END PGP PRIVATE KEY BLOCK-----',
  ];
  bool isOpenPgp = pem.indexOf('BEGIN PGP') != -1;

  for (String s in startsWith) {
    if (pem.startsWith(s)) {
      pem = pem.substring(s.length);
    }
  }

  for (String s in endsWith) {
    if (pem.endsWith(s)) {
      pem = pem.substring(0, pem.length - s.length);
    }
  }

  if (isOpenPgp) {    int index = pem.indexOf('\r\n');
    pem = pem.substring(0, index);
  }

  pem = pem.replaceAll('\n', '');
  pem = pem.replaceAll('\r', '');

  return pem;
}

String encodePublicKeyToPem(PublicKey publicKey) {
String dataBase64 = publicKey.toString();
return '''-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----''';
}

String encodePrivateKeyToPem(PrivateKey privateKey) {
String dataBase64 = privateKey.toString();
return '''-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----''';
}