import 'dart:convert';

import 'package:gitcoin/gitcoin.dart';
import 'package:http/http.dart';

class GithubWorker {
  final String username;
  final String publicKey;
  final StorageManager storageManager;

  GithubWorker(this.username, this.publicKey, this.storageManager);

  getPullRequests() async {
    String url = 'https://api.github.com/search/issues?q=author:konstantinullrich+is:pr+is:merged';
    Response response =  await get(url);
    return jsonDecode(response.body);
  }

  generateRevenue() async {
    List<Transaction> openTrx = [];
    List<Block> blockList = this.storageManager.BlockchainBlocks;
    Map pullRequests = await getPullRequests();
    List items = pullRequests["items"];
    for (Map item in items) {
      String from_url = item["html_url"];
      int score = item["score"].round();
      bool isInChain = findInBlockList(blockList, "fromAddress", from_url);
      if (!isInChain)
        openTrx.add(Transaction(from_url, this.publicKey, score));
    }
    for (Transaction trx in openTrx) {
      storageManager.storePendingTransaction(trx);
    }
  }
}