import 'dart:async';
import 'dart:collection';

import 'package:bot_manager_mobile_app/widgets/bots_list_widget.dart';
import 'package:bot_manager_mobile_app/models/game_model.dart';
import 'package:bot_manager_mobile_app/resources/api_provider.dart';
import 'package:flutter/material.dart';

import 'bot_property_detail_widgets.dart';
import 'custom/drawer_builder.dart';

class GamesListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GamesListWidgetState();
  }
}

class GamesListWidgetState extends State<GamesListWidget> {
  List<GameInfo> _games = List<GameInfo>();
  Map<int, bool> expandedByGameId = HashMap();

  Future<GameInfoList> loadGames() {
    return ApiProvider.httpGet(ApiProvider.gameInfoListResource);
  }

  ExpansionTile _buildGameTile(GameInfo game) {
    return ExpansionTile(
      leading: buildGameLeadingIcon(game),
      initiallyExpanded: expandedByGameId[game.id] == true,
      onExpansionChanged: (isExpanded) {
        expandedByGameId[game.id] = isExpanded;
      },
      title: Text(game.name, style: TextStyle(fontSize: 22)),
      subtitle: Text('Running bots : ${game.botInfoList.length} (active : ${game.botInfoList.where((e) => e.state == "ACTIVE").length})'),
      children: <Widget>[
        BotsListWidget(gameInfo: game),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text("New Bot"),
              onPressed: () => _createBot(game),
            ),
          ),
        )
      ],
    );
  }

  void _createBot(GameInfo game) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BotCreationWidget(
                  game: game,
                )));
  }

  Widget buildGameLeadingIcon(GameInfo game) {
    return game.iconPath == null
        ? Icons.games
        : AspectRatio(
            aspectRatio: 1.5,
            child: new Container(
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0),
                    bottomLeft: const Radius.circular(15.0),
                    bottomRight: const Radius.circular(15.0),
                  ),
                  border: Border.all(),
                  image: new DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(game.iconPath),
                  )),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        setState(() {});
        return Future(() => 1);
      },
      child: Scaffold(
        drawer: buildDrawer(context, setState),
        appBar: AppBar(
          title: Text('Bot Manager'),
        ),
        body: FutureBuilder<GameInfoList>(
          future: loadGames(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Stack(
                children: <Widget>[
                  buildGamesListWidget(),
                  LinearProgressIndicator(),
                ],
              );
            }
            if (!snapshot.hasError) {
              this._games = snapshot.data.gameInfoList;
              return buildGamesListWidget();
            }
            return Center(
              child: Text(
                "Error accessing server",
                style: TextStyle(fontSize: 30),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGamesListWidget() {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        thickness: 5,
      ),
      itemCount: _games.length,
      itemBuilder: (context, index) => _buildGameTile(_games[index]),
    );
  }
}
