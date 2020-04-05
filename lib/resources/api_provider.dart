import 'dart:convert';

import 'package:bot_manager_mobile_app/models/bot_log_model.dart';
import 'package:bot_manager_mobile_app/models/bot_model.dart';
import 'package:bot_manager_mobile_app/models/bot_operation_model.dart';
import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:bot_manager_mobile_app/models/bot_task_model.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ApiProvider {

  static const PROD_PORT = 35678;
  static const TEST_PORT = 35679;

  static String srvHost = '145.239.76.24';
  static int srvPort;

  static String buildBaseUrl() {
    return "http://$srvHost:$srvPort/";
  }

  static Future<T> load<T>(Resource<T> resource, Function() responseCaller) async {
    Response response = await responseCaller();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('${response.data}');
      return resource.parse(response);
    } else {
      throw Exception("${response.statusCode} : ${json.decode(response.data)["message"]}");
    }
  }

  static Future<T> httpGet<T>(Resource<T> resource) async {
    final responseCaller = () => new Dio().get(
          "${buildBaseUrl()}/${resource.url}",
          options: Options(
            responseType: ResponseType.plain,
            validateStatus: (status) => status <= 500,
          ),
        );
    return load(resource, responseCaller);
  }

  static Future<T> httpPost<T>(Resource<T> resource, [Object body]) async {
    body ??= "";
    final responseCaller = () => new Dio().post(
          "${buildBaseUrl()}/${resource.url}",
          data: json.encode(body),
          options: Options(
            responseType: ResponseType.plain,
            validateStatus: (status) => status <= 500,
          ),
        );
    return load(resource, responseCaller);
  }

  static Resource<Null> postTransition(int botId, String transition) {
    return Resource(
      url: "/bots/bot/$botId/transition/$transition",
      parse: (response) {
        return null;
      },
    );
  }

  static Resource<GameInfoList> get gameInfoListResource {
    return Resource(
      url: "/bots/all",
      parse: (response) {
        return GameInfoList.fromJson(json.decode(response.data.toString()));
      },
    );
  }

  static Resource<BotInfo> getBotInfoResource(int botId) {
    return Resource(
      url: "/bots/bot/$botId",
      parse: (response) {
        return BotInfo.fromJson(json.decode(response.data.toString()));
      },
    );
  }

  static Resource<BotInfo> createBotResource(int gameId) {
    return Resource(
      url: "/bots/$gameId/create",
      parse: (response) {
        return BotInfo.fromJson(json.decode(response.data));
      },
    );
  }

  static Resource<BotOperationList> getBotOperationsResource(int botId) {
    return Resource(
      url: "/bots/bot/$botId/operations",
      parse: (response) {
        return BotOperationList.fromJson(json.decode(response.data.toString()));
      },
    );
  }

  static Resource<OperationResult> postCallOperationResource(int botId, int operationId) {
    return Resource(
      url: "/bots/bot/$botId/operation/$operationId/call",
      parse: (response) {
        return OperationResult.fromJson(json.decode(response.data.toString()));
      },
    );
  }

  static Resource<BotPropertyList> getGamePropertiesResource(int gameId) {
    return Resource(
      url: "/bots/$gameId/properties",
      parse: (response) {
        return BotPropertyList.fromJson(json.decode(response.data.toString()));
      },
    );
  }

  static Resource<BotPropertyList> getGameLoginPropertiesResource(int gameId) {
    return Resource(
      url: "/bots/$gameId/loginProperties",
      parse: (response) {
        return BotPropertyList.fromJson(json.decode(response.data.toString()));
      },
    );
  }

  static Resource<Map<String, dynamic>> getBotPropertiesResource(int botId) {
    return Resource(
      url: "/bots/bot/$botId/properties",
      parse: (response) {
        return json.decode(response.data.toString());
      },
    );
  }

  static Resource<Map<String, dynamic>> updateBotPropertiesResource(int botId) {
    return Resource(
      url: "/bots/bot/$botId/properties",
      parse: (response) {
        return json.decode(response.data) as Map<String, dynamic>;
      },
    );
  }

  static Resource<List<BotLog>> getBotLogsResource(int botId) {
    return Resource(
      url: "/bots/bot/$botId/logs",
      parse: (response) {
        return (json.decode(response.data.toString()) as List).map((e) => BotLog.fromJson(e)).toList();
      },
    );
  }

  static Resource<BotTaskList> getBotTasksResource(int botId) {
    return Resource(
      url: "/bots/bot/$botId/tasks",
      parse: (response) {
        return BotTaskList.fromJson(json.decode(response.data.toString()));
      },
    );
  }
}

class Resource<T> {
  final String url;
  T Function(Response response) parse;

  Resource({this.url, this.parse});
}
