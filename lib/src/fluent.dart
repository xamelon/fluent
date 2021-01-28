library fluent;

import 'package:meta/meta.dart';

import 'dart:async';
import './map.dart';

typedef FutureOr<Map<String, dynamic>> EffectHandler(Map<String, dynamic> state, [dynamic args]);

class Fluent {
  static final Fluent fluent = Fluent._();

  Fluent._();

  bool saveHistory = true;

  Map<String, dynamic> state = {};
  
  Map<String, EffectHandler> _effects = {};

  Map<String, StreamController> _subs = {};

  List<Map<String, Map>> hx = List.empty(growable: true);

  static void dispatch(String eventName, List args) async {
    EffectHandler handler = fluent._effects[eventName];
    if (handler == null) {
      return;
    }
    
        
    Map diffMap = await Function.apply(handler, [fluent.state]..addAll(args));
    fluent.state = diffMap;
    List<String> allPaths = diffMap.findAllPaths();
    
    List changedKeys = allPaths.where((el) => fluent._subs.containsKey(el)).toList();
    
    if(changedKeys != null) {
      changedKeys.forEach((el) {
          StreamController ctrl = fluent._subs[el];
          var val = diffMap.getIn(el);
          
          ctrl.add(val);
        });
      }
      
      if (fluent.saveHistory) {
        fluent.hx.add({eventName: diffMap});
      }
    
  }

  static void regEffect(
    String eventName, EffectHandler handler) {
    fluent._effects[eventName] = handler;
  }

  void _cleanSubscribers(String path) {
    fluent._subs[path] = null;
  }
  
  static Stream regSub(String path) {
    
    StreamController controller = fluent._subs[path];
    if (controller == null) {
      controller = StreamController(onCancel: () {
          Fluent.fluent._cleanSubscribers(path);
      });
      fluent._subs[path] = controller;
    }

    return controller.stream;
  }

  void clearHx() => hx.clear();
}
