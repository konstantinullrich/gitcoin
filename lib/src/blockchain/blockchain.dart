import 'dart:core';

import 'package:gitcoin/gitcoin.dart';

class Blockchain {
  Wallet creatorWallet;
  Broadcaster broadcaster;
  StorageManager storageManager;
  List<Block> chain = [];

  /// Returns the Hash of the last Block of the Blockchain
  String get _previousHash => this.chain.last.toHash();

  /// Returns the number of objects in this list.
  ///
  /// The valid indices for a list are `0` through `length - 1`.
  int get length => chain.length;

  /// Returns if the Blockchain is valid
  bool get isValid {
    Block last_block = this.chain.first;
    for (int i = 1; i < this.chain.length; i++) {
      Block block = this.chain[i];
      if (block.previousHash != last_block.toHash() || !block.isValid) {
        return false;
      }
      last_block = block;
    }
    return true;
  }

  Blockchain(this.creatorWallet, this.storageManager, {this.broadcaster=null}) {
    this.chain.add(Block(TransactionList(), ""));
  }

  Blockchain.fromList(List<Map> unresolvedQuery) {
    unresolvedQuery.forEach((block) {
      chain.add(Block.fromMap(block));
    });
  }

  /// Add a Block to the Blockchain and inform other Nodes about the Update
  /// to reach Consensus
  void _addBlock(Block block) {
    chain.add(block);
    storageManager.storeBlockchain(this);
    this.broadcaster.broadcast({"method": "NEW_BLOCK", "block": block.toMap()});
  }

  /// Create a Block and add it to the ever growing Blockchain
  void createBlock() {
    String creator = RsaKeyHelper.encodePublicKeyToString(this.creatorWallet.publicKey);
    Block block = Block(storageManager.pendingTransactions, creator);
    storageManager.deletePendingTransactions();
    block.previousHash = this._previousHash;
    block.signBlock(this.creatorWallet.privateKey);
    this._addBlock(block);

  }

  /// Resolve Conflicts occurred in any other process
  bool resolveConflicts(List<Blockchain> chains) {
    Blockchain newChain = this;
    bool isThisChain = true;
    for (Blockchain blockchain in chains) {
      if (blockchain.isValid && (blockchain.length > newChain.length)) {
        newChain = blockchain;
        isThisChain = false;
      }
    }
    return isThisChain;
  }

  /// Return the Blockchain as a List
  List<Map<String, dynamic>> toList() {
    List<Map<String, dynamic>> result = [];
    chain.forEach((block) {
      result.add(block.toMap());
    });
    return result;
  }


  /// Return the Blockchain as Valid JSON String
  @override
  String toString() {
    String result = '[';
    int index = 0;
    chain.forEach((block) {
      if (index+1 == chain.length) {
        result += '${block.toString()}';
      } else {
        result += '${block.toString()},';
      }
      index++;
    });
    result += ']';
    return result;
  }
}