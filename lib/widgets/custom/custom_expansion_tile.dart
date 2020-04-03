
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildExpansionTileWithoutDivider(BuildContext context, ExpansionTile expansionTile) {
  final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
  return Theme(data: theme, child: expansionTile);
}