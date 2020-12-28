import 'package:flutter/material.dart';

import './debug_list_item.dart';

class MapView extends StatefulWidget {

  Map map;
  int level;
  
  MapView(this.map, this.level);

  @override
  State<MapView> createState() => _MapViewState();
  
}

class _MapViewState extends State<MapView> {

  Map<String, bool> expandedKeys = {};

  @override
  initState() {
    super.initState();
    print("Level: ${this.widget.level}");
    this.widget.map.keys.forEach((v) { expandedKeys[v] = false; });
  }
  
  @override
  Widget build(BuildContext context) {

    List<String> keys = expandedKeys.keys.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: keys.length,
      itemBuilder: (BuildContext context, int i) {
        String key = keys[i];
        var val = this.widget.map[key];
        return DebugListItem(key, val, expandedKeys[key], () {
            expandedKeys[key] = !expandedKeys[key];
            setState((){});
          },
          this.widget.level,
        );
      }
    );
  }
  
}
