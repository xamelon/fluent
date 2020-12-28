import 'package:flutter/material.dart';

import './map_view.dart'; 

class DebugListItem extends StatelessWidget {

  bool expanded;
  String k;
  var value;
  Function onPressed;
  int level;

  DebugListItem(this.k, this.value, this.expanded, this.onPressed, this.level);
  
  bool canBeExpanded() => (value is Map || value is List);

  Widget childForExpanded() {
    if(expanded) {
      if(value is Map) {
        return MapView(value, level > 3 ? level : level++);
      } else if(value is List) {
        Map targetMap = value.asMap();
        return MapView(targetMap, level > 3 ? level : level++);
      }
    }

    return Container();
  }

  Widget wrapInGestureDetector({Widget child}) {
    if(canBeExpanded()) {
      return InkWell(
        onTap: this.onPressed,
        child: child,
      );
    }
    return child;
  }
  
  @override
  Widget build(BuildContext context) {
    return 
      Container(
        constraints: BoxConstraints(minHeight: 30),
        padding: EdgeInsets.only(left: 30 * level.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          wrapInGestureDetector(
            child:Row(children: [
              if(canBeExpanded())
              Icon(expanded ? Icons.arrow_drop_down : Icons.arrow_right),
              Container(width: 5),
              Text("$k:", style: TextStyle(color: Colors.teal)),
              Container(width: 5),
              if(!canBeExpanded())
              Expanded(child: Text("$value")),
        ]),),
        childForExpanded(),
        Container(
          height: 1.0,
          color: Colors.grey,
          
        ),
        ],
    ),
    );
  }
  
}
