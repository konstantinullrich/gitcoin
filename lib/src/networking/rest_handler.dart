import 'dart:convert';
import 'dart:io';

import 'package:crypton/crypton.dart';
import 'package:gitcoin/gitcoin.dart';

/// GET  '/blockchain/full'         => get full Blockchain as Array
/// GET  '/wallet?walletId=walletid'=> get current funds of walletId
/// POST '/transaction'             => receive broadcasted Transactions
/// PUT  '/transaction'             => create new Transactions
/// POST '/block'                   => receive broadcasted Blocks

const String FULL_BLOCKCHAIN = '/blockchain/full';
const String WALLET = '/wallet';
const String TRANSACTION = '/transaction';
const String BLOCK = '/block';

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
    print('Gitcoin Server running on "http://${server.address.address}:${server.port.toString()}"');

    await for (HttpRequest request in server) {
      List<Block> blockList = storageManager.BlockchainBlocks;
      HttpResponse response = request.response;
      response.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
      response.headers.add('Access-Control-Allow-Origin', '*');
      response.headers.add('Access-Control-Allow-Methods', '*');
      response.headers.add('Access-Control-Allow-Headers', '*');
      switch (request.method) {
        case 'GET':
          switch(request.requestedUri.path) {
            case FULL_BLOCKCHAIN:
              response.write(
                  jsonEncode(this._blockListToMap(blockList))
              );
              break;
            case WALLET:
              String walletAddress = request.uri.queryParameters['walletId'];
              response.write(
                  jsonEncode({
                    'funds': getFundsOfAddress(storageManager, walletAddress)
                  })
              );
              break;
          }
          break;
        case 'POST':
          String content = await utf8.decoder.bind(request).join();
          Map rawMap = jsonDecode(content);
          switch (request.requestedUri.path) {
            case TRANSACTION:
              Transaction trx = Transaction.fromMap(rawMap);
              if (trx.isValid) storageManager.storePendingTransaction(trx);
              break;
            case BLOCK:
              Block blc = Block.fromMap(rawMap);
              if (blc.isValid) storageManager.storePendingBlock(blc);
              break;
          }
          response.write('You are connected to the gitcoin chain!');
          break;
        case 'PUT':
          String content = await utf8.decoder.bind(request).join();
          Map rawMap = jsonDecode(content);
          switch (request.requestedUri.path) {
            case TRANSACTION:
              ECPrivateKey privateKey = ECPrivateKey.fromString(rawMap['secretKey']);
              String senderAddress = privateKey.publicKey.toString();
              if (!(getFundsOfAddress(storageManager, senderAddress) >= rawMap['amount'])) {
                response.statusCode = 401;
                response.write('You can\'t spend more than you have!');
                break;
              }
              Transaction trx = Transaction(
                  senderAddress,
                  rawMap['toAddress'],
                  rawMap['amount']
              );
              trx.signTransaction(privateKey);
              storageManager.storePendingTransaction(trx);
              break;
          }
          response.write('You are connected to the gitcoin chain!');
          break;
        default:
          response.write('You are connected to the gitcoin chain!');
          break;
      }
      await response.close();
    }
  }
}