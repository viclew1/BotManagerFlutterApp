
import 'dart:convert';

import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:http/http.dart';

class ApiProvider {

  static const BASE_URL = 'http://145.239.76.24:35678/';

  static Future<T> load<T>(Resource<T> resource) async {
    try {
      final response = await new Client().get(resource.url);
      if (response.statusCode == 200) {
        return resource.parse(response);
      } else {
        throw Exception('Failed to load games');
      }
    } catch(e) {
      throw Exception('Something went wrong, please try again. ${e.toString()}');
    }
  }

  static Resource<GameInfoList> get gameInfoListResource {
    return Resource(
        url: "$BASE_URL/bots/all",
        parse: (response) {
          return GameInfoList.fromJson(json.decode(response.body));
        }
    );
  }

  static Resource<BotPropertyList> getGamePropertiesResource(int gameId) {
    return Resource(
        url: "$BASE_URL/bots/$gameId/properties",
        parse: (response) {
          return BotPropertyList.fromJson(json.decode(response.body));
        }
    );
  }

  static Resource<Map<String, dynamic>> getBotPropertiesResource(int botId) {
    return Resource(
        url: "$BASE_URL/bots/bot/$botId/properties",
        parse: (response) {
          return json.decode(response.body);
        }
    );
  }

}

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url,this.parse});
}