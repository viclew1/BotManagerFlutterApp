class BotProperty {

  String key;
  String type;
  String description;
  bool needed;
  bool nullable;
  dynamic defaultValue;
  List<dynamic> acceptedValues;

  BotProperty({
    this.key,
    this.type,
    this.description,
    this.needed,
    this.nullable,
    this.defaultValue,
    this.acceptedValues
  });

  factory BotProperty.fromJson(Map<String, dynamic> json) {
    return BotProperty(
      key: json["key"],
      type: json["type"],
      description: json["description"],
      needed: json["needed"],
      nullable: json["nullable"],
      defaultValue: json["default_value"],
      acceptedValues: json["accepted_values"] as List
    );
  }

}

class BotPropertyList {

  List<BotProperty> botProperties;

  BotPropertyList({
    this.botProperties
  });

  factory BotPropertyList.fromJson(Map<String, dynamic> json) {
    return BotPropertyList(
        botProperties: (json["bot_properties"] as List).map((i) => BotProperty.fromJson(i)).toList()
    );
  }
}
