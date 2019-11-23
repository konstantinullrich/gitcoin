import 'dart:convert';

import 'package:http/http.dart';


class Broadcaster {
  List<String> nodes = [];
  Broadcaster(this.nodes);
  void broadcast(Map message) {
    String broadcastMessage = jsonEncode(message);
    for (String node in this.nodes) {
        post(node, headers: {"Content-Type": "application/json"},
            body: broadcastMessage
        ).timeout(Duration(minutes: 1)).catchError(print);
    }
  }
}