import 'package:gitcoin/gitcoin.dart';

bool findInBlockList(List<Block> blocklist, String query_name, String query_value) {
  for (Block blc in blocklist) {
    Map blc_map = blc.toMap();
    List<Map> transactions = blc_map["data"];
    for (Map transaction in transactions) {
      if(transaction[query_name] == query_value)
        return true;
    }
  }
  return false;
}