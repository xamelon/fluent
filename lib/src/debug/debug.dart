import 'package:flutter/material.dart';

import './map_view.dart';
import 'package:fluent/fluent.dart';

class FluentDebug extends StatefulWidget {
  State<FluentDebug> createState() => _FluentDebugState();
}

class _FluentDebugState extends State<FluentDebug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fluent Debug")),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: MapView(Fluent.fluent.state, 0),
            ),
          ],
        ),
      ),
    );
  }
}
