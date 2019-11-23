import 'dart:convert';
import 'dart:io';

import 'package:gitcoin/gitcoin.dart';

/// GET "/blockchain/full"          => get full Blockchain as Array
/// GET "/wallet?walletId=walletid" => get current funds of walletId
/// POST "/transaction"             => receive broadcasted Transactions
/// POST "/block"                   => receive broadcasted Blocks



const String FULL_BLOCKCHAIN = "/blockchain/full";
const String WALLET = "/wallet";
const String TRANSACTION = "/transaction";
const String BLOCK = "/block";

class RestHandler {

  final StorageManager storageManager;
  final int port;
  final InternetAddress host = InternetAddress.anyIPv4;

  List _blockListToMap(List<Block> blcList) {
    List<Map> result = [];
    for (Block blc in blcList) {
      result.add(blc.toMap());
    }
    return result;
  }

  RestHandler(this.storageManager, this.port);

  Future run() async {
    HttpServer server = await HttpServer.bind(
      this.host,
      this.port
    );
    print("Gitcoin Server running on 'http://${server.address.address}:${server.port.toString()}'");

    await for (HttpRequest request in server) {
      List<Block> blockList = storageManager.BlockchainBlocks;
      switch (request.method) {
        case "GET":
          switch(request.requestedUri.path) {
            case FULL_BLOCKCHAIN:
              request.response.write(this._blockListToMap(blockList));
              break;
            case WALLET:
              String walletAddress = request.uri.queryParameters["walletId"];
              request.response.write({ "funds": getFundsOfAddress(blockList, walletAddress) });
              break;
          }
          break;
        case "POST":
          String content = await utf8.decoder.bind(request).join();
          Map rawMap = jsonDecode(content);
          switch (request.requestedUri.path) {
            case TRANSACTION:
              Transaction trx = Transaction.fromMap(rawMap);
              storageManager.storePendingTransaction(trx);
              break;
            case BLOCK:
              Block blc = Block.fromMap(rawMap);
              storageManager.storePendingBlock(blc);
              break;
          }
          request.response.write('You are connected to the gitcoin chain!');
          break;
        default:
          request.response.write('You are connected to the gitcoin chain!');
      }
      await request.response.close();
    }
  }
}