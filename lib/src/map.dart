library fluent;

import './path.dart';

extension MapHelper on Map {
  dynamic getIn(String path) {
    List<String> paths = PathHelper.extractPath(path);

    return paths.fold(this, (pr, e) {
      if (pr is Map) {
        return pr[e];
      } else {
        return null;
      }
    });
  }

  void addIn(String path, dynamic value) {
    List<String> paths = PathHelper.extractPath(path);

    //"momo/test"
    //[momo][test]
    Map rootMap = findMapInKey(path);
    if (value is Map && rootMap[paths.last] is Map) {
      rootMap[paths.last].addAll(value);
    } else {
      rootMap[paths.last] = value;
    }
  }

  void removeIn(String path) {
    List<String> paths = PathHelper.extractPath(path);

    Map rootMap = findMapInKey(path);
    rootMap.remove(paths.last);

    rootMap = this;
    for (int i = 0; i < paths.length - 1; i++) {
      String key = paths[i];
      if (!rootMap.containsKey(key)) return;
      if (rootMap.containsKey(key) &&
          rootMap[key] is Map &&
          rootMap[key].isEmpty) {
        rootMap.remove(key);
        return;
      }

      rootMap = rootMap[key];
    }
  }

  Map findMapInKey(String path) {
    List<String> paths = PathHelper.extractPath(path);

    Map<dynamic, dynamic> rootMap = this;
    for (int i = 0; i < paths.length; i++) {
      dynamic k = paths[i];
      if (!rootMap.containsKey(k) && i < paths.length - 1) {
        rootMap[k] = new Map();
      } else if (i == paths.length - 1) {
        return rootMap;
        break;
      }
      rootMap = rootMap[k];
    }
  }

  List<String> findAllPaths([String rootPath = null]) {
    List<String> allPaths = [];

    this.forEach((k, v) {
      String path = k;
      if (rootPath != null) {
        path = rootPath + "/" + k;
      }
      allPaths.add(path);
      if (v is Map) {
        allPaths.addAll(v.findAllPaths(k));
      }
    });

    return allPaths;
  }

  Map<String, dynamic> diff(Map<String, dynamic> other) {
    Set<String> allPaths = Set.from(this.findAllPaths())
      ..addAll(other.findAllPaths());

    Map<String, dynamic> diff = {};

    allPaths.forEach((path) {
      var oldValue = this.getIn(path);
      var newValue = other.getIn(path);
      if (oldValue != newValue) {
        diff.addIn(path + "/old", oldValue);
        diff.addIn(path + "/new", newValue);
      }
    });

    return diff;
  }
}
