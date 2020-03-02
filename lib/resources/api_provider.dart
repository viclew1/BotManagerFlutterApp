
import 'dart:convert';

import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:http/http.dart';

class ApiProvider {

  static const BASE_URL = 'http://10.0.2.2:8080/';

  Client client = new Client();

  List<dynamic> genres = <dynamic>[];

  Future<GameInfoList> fetchGameInfoList() async {
    try {
      final response = await client.get("$BASE_URL/bots/all");
      if (response.statusCode == 200) {
        return GameInfoList.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load games');
      }
    } catch(e) {
      throw Exception('Something went wrong, please try again. ${e.toString()}');
    }
  }

}