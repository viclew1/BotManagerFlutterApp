import 'package:bot_manager_mobile_app/models/bot_property_model.dart';

class BotOperation {
  int id;
  String label;
  List<BotProperty> params;

  BotOperation({this.id, this.label, this.params});

  factory BotOperation.fromJson(Map<String, dynamic> json) {
    return new BotOperation(
      id: json["id"],
      label: json["label"],
      params: (json["params"] as List).map((i) => BotProperty.fromJson(i)).toList(),
    );
  }
}

class BotOperationList {
  List<BotOperation> botOperations;

  BotOperationList({this.botOperations});

  factory BotOperationList.fromJson(Map<String, dynamic> json) {
    return BotOperationList(botOperations: (json["bot_operations"] as List).map((i) => BotOperation.fromJson(i)).toList());
  }
}

class OperationResult {
  bool isSuccess;
  String message;
  dynamic content;
  String resultType;

  OperationResult({this.isSuccess, this.message, this.content, this.resultType});

  factory OperationResult.fromJson(Map<String, dynamic> json) {
    return new OperationResult(
      isSuccess: json["is_success"],
      message: json["message"],
      content: json["content"],
      resultType: json["result_type"]
    );
  }
}