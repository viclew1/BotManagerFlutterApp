import 'dart:convert';

import 'package:bot_manager_mobile_app/ui/games_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'blocs/games_bloc_widget.dart';

void main() => runApp(MaterialApp(
  title: "Poke App",
  home: HomePage(),
  debugShowCheckedModeBanner: false,
));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _onRefresh,
        header: WaterDropHeader(),
        controller: _refreshController,
        child: new GamesBlocWidget(
          child: new Container(
            child: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new BottomAppBar(),
                new MoviesList()
              ],
            ),
          ),
        )
      )
    );
  }

  void _onRefresh() async {

  }
}