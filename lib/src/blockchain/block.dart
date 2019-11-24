import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:gitcoin/gitcoin.dart';
import 'package:pointycastle/export.dart';

class Block {
  TransactionList data;
  String previousHash = "0x0";
  String creator = "";
  String signature = "";
  int nuance = 0;
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  Block(this.data, this.creator);

  Block.fromMap(Map<String, dynamic> unresolvedBlock) {
    if (
    unresolvedBlock.containsKey("data") &&
        unresolvedBlock.containsKey("creator") &&
        unresolvedBlock.containsKey("signature") &&
        unresolvedBlock.containsKey("timestamp") &&
        unresolvedBlock.containsKey("previousHash") &&
        unresolvedBlock.containsKey("nuance")
    ) {
      this.data = TransactionList.fromList(unresolvedBlock["data"]);
      this.creator = unresolvedBlock["creator"];
      this.signature = unresolvedBlock["signature"];
      this.timestamp = unresolvedBlock["timestamp"];
      this.previousHash = unresolvedBlock["previousHash"];
      this.nuance = unresolvedBlock["nuance"];
    } else {
      throw("Some Parameter are missing!");
    }
  }

  bool get isValid {
    RSAPublicKey publicKey = RsaKeyHelper.parsePublicKeyFromString(this.creator);
    bool hasValidSignature = RsaKeyHelper.validateStringSignature(this.toHash(), this.signature, publicKey);
    return this.data.isValid && hasValidSignature;
  }

  void signBlock(PrivateKey privateKey) {
    RSASignature sig= RsaKeyHelper.createSignature(this.toHash(), privateKey);
    signature = base64Encode(sig.bytes);
  }

  String toHash() {
    crypto.Digest digest = crypto.sha256.convert(
        utf8.encode(this.toString())
    );
    return digest.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      "data": this.data.toList(),
      "creator": this.creator,
      "signature": this.signature,
      "timestamp": this.timestamp,
      "nuance": this.nuance,
      "previousHash": this.previousHash
    };
  }

  String toString() {
    return
        this.nuance.toString() +
        this.creator +
        this.data.toString() +
        this.previousHash +
        this.timestamp.toString();
  }
}