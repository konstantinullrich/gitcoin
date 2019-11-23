
import 'package:gitcoin/utils/rsa_pem.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';

void main() {
  group('A group of Key Tests', () {
    AsymmetricKeyPair<PublicKey, PrivateKey> keyPair;
    RSAPrivateKey privateKey;
    RSAPublicKey publicKey;

    setUp(() {
      keyPair = RsaKeyHelper.generateKeyPair();
      privateKey = keyPair.privateKey;
      publicKey = keyPair.publicKey;
    });

    test('Test private Key to string and back', () {
      String privateKeyString = RsaKeyHelper.encodePrivateKeyToString(privateKey);
      RSAPrivateKey privateKey2 = RsaKeyHelper.parsePrivateKeyFromString(privateKeyString);
      expect(privateKey2, privateKey);
    });

    test('Test public Key to string and back', () {
      String publicKeyString = RsaKeyHelper.encodePublicKeyToString(publicKey);
      RSAPublicKey publicKey2 = RsaKeyHelper.parsePublicKeyFromString(publicKeyString);
      expect(publicKey2, publicKey);
    });
  });
}
