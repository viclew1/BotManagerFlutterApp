import 'dart:collection';

import 'package:bot_manager_mobile_app/models/bot_property_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BotPropertiesWidget extends StatefulWidget {
  final Map<BotProperty, dynamic> props;
  final Map<BotProperty, dynamic> initialProps;
  final Function(Function()) setStateFun;

  BotPropertiesWidget(this.props, this.setStateFun) : this.initialProps = props.map((k, v) => MapEntry(k, v));

  bool propertiesFilled() {
    return props.keys.where((e) => e.needed && !e.nullable).where((e) => props[e] == null || props[e].toString().isEmpty).isEmpty;
  }

  bool valueChanged() {
    return initialProps.entries
        .where((e) => initialProps[e.key].toString() != props[e.key].toString())
        .where((e) => initialProps[e.key] != null || props[e.key].toString() != "")
        .where((e) => props[e.key] != null || initialProps[e.key].toString() != "")
        .isNotEmpty;
  }

  Map<String, String> buildPropsAsMapStringString() {
    Map<String, String> propsStrStr = HashMap();
    props.entries.where((e) => e.value != null).forEach((e) => propsStrStr[e.key.key] = e.value.toString());
    return propsStrStr;
  }

  @override
  State<StatefulWidget> createState() {
    return BotPropertiesState(props, setStateFun);
  }

  void updateInitialProps(Map<String, dynamic> newProps) {
    initialProps.keys.forEach((k) {
      initialProps[k] = newProps[k.key];
      props[k] = newProps[k.key];
    });
  }
}

class BotPropertiesState extends State<BotPropertiesWidget> {
  final Map<BotProperty, dynamic> props;
  final Function(Function()) setStateFun;

  BotPropertiesState(this.props, this.setStateFun);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: props.length,
        itemBuilder: (context, index) {
          return _buildPropertyTile(props, props.keys.elementAt(index));
        });
  }

  Widget _buildPropertyTile(Map<BotProperty, dynamic> props, BotProperty key) {
    return ListTile(
      title: Tooltip(
        showDuration: Duration(seconds: 5),
        message: key.description,
        child: Text(key.key),
      ),
      trailing: Container(
        width: 70,
        child: buildPropertyInputWidget(key, props[key]),
      ),
    );
  }

  buildPropertyInputWidget(BotProperty key, propValue) {
    switch (key.type) {
      case "BOOLEAN":
        return Switch(
          activeTrackColor: Theme.of(context).primaryColor,
          activeColor: Theme.of(context).accentColor,
          value: propValue == null ? "" : propValue,
          onChanged: (value) {
            setStateFun(() {});
            setState(() {
              props[key] = value;
            });
          },
        );
      case "INTEGER":
      case "FLOAT":
        return TextFormField(
          onChanged: (value) {
            setStateFun(() {});
            setState(() {
              props[key] = value;
            });
          },
          initialValue: propValue == null ? "" : propValue.toString(),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly], // Only numbers can be entered
        );
      default:
        return TextFormField(
          onChanged: (value) {
            setStateFun(() {});
            setState(() {
              props[key] = value;
            });
          },
          initialValue: propValue == null ? "" : propValue.toString(),
          textAlign: TextAlign.center,
        );
    }
  }
}
