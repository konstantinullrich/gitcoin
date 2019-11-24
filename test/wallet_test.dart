
import 'package:gitcoin/gitcoin.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';

void main() {
  group('A group of RSAKey Tests', () {
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
  group('A group of ECWalletTests', () {
    ECWallet wallet;

    setUp(() {
      wallet = ECWallet.fromRandom();
    });

    test('Test private Key to string and back', () {
      wa
      expect(privateKey2, privateKey);
    });

    test('Test public Key to string and back', () {
      String publicKeyString = RsaKeyHelper.encodePublicKeyToString(publicKey);
      RSAPublicKey publicKey2 = RsaKeyHelper.parsePublicKeyFromString(publicKeyString);
      expect(publicKey2, publicKey);
    });
  });
}
