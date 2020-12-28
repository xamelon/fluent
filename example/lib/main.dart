import 'package:flutter/material.dart';

import 'package:fluent/fluent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Map<String, dynamic> onClick([clickedCount]) {
    var oldValue = clickedCount ?? 0;
    return {}..addIn("Clicked", oldValue + 1);
  }
  
  @override
  initState() {
    super.initState();
    Fluent.regEffect(
      "Main/ButtonClicked",
      ["Clicked"],
      onClick,
    );
    Fluent.fluent.state.addIn("Main/Button/Title", "Some button is here");
    Fluent.fluent.state.addIn("Main/Button/Opacity", "Some opacity for button");
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              initialData: 0,
              stream: Fluent.regSub("Clicked"),
              builder: (BuildContext context, AsyncSnapshot data) {
                return Text(
                  '${data.data}',
                  style: Theme.of(context).textTheme.headline4,
                );
            }),
            RaisedButton(
              child: Text("Open fluent debug page"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FluentDebug()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Fluent.dispatch("Main/ButtonClicked", []);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
