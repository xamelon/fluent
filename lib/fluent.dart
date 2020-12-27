library fluent;

import 'package:fluent/mapping.dart';
import 'package:fluent/map.dart';

class Fluent {
  Map<String, dynamic> state = {};

  Map<String, List<Mapping>> effects = {};

  Map<String, Stream> subs = {};

  void dispatch(String eventName, List args) {
    List<Mapping> mappings = effects[eventName];
    mappings.forEach((m) {
      List<dynamic> handlerArgs = m.args.map((a) => state.getIn(a)).toList()
        ..addAll(args);
      print("Handler args: $handlerArgs");
      Map diffMap = Function.apply(m.handler, handlerArgs);

      print("Diff map: $diffMap");
      state.addAll(diffMap);
      
    });
  }

  void regEffect(String eventName, List<String> args,
      Map<String, dynamic> Function([dynamic args]) handler) {
    if (effects.containsKey(eventName)) {
      effects[eventName].add(Mapping(args, handler));
    } else {
      effects[eventName] = List<Mapping>()..add(Mapping(args, handler));
    }
  }

  void regSub(String path, Stream stream) {
    
  }

  
  
}
