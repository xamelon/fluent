import 'package:flutter_test/flutter_test.dart';

import 'package:fluent/fluent.dart';

void main() {
  test("get in path", () {
    Map<String, dynamic> someMap = {
      "test": {"test": 123},
      "momo": {"123": "haha"}
    };

    expect(someMap.getIn("test/test"), 123);
    expect(someMap.getIn("momo/123"), "haha");
    expect(someMap.getIn("momo"), {"123": "haha"});
    expect(someMap.getIn("Basket/coupons"), null);
  });

  test("add in path", () {
    Map<String, dynamic> someMap = {};

    someMap.addIn("test/test", 123);
    expect(someMap.getIn("test/test"), 123);
    someMap.addIn("test/momo", 44);
    expect(someMap.getIn("test/momo"), 44);
    someMap.addIn("bb", 46);
    expect(someMap.getIn("bb"), 46);

    someMap.addIn("bb", {"key": "value"});
    expect(someMap.getIn("bb"), {"key": "value"});

    someMap.addIn("bb", {"tortik": "cake"});
    expect(someMap.getIn("bb"), {"key": "value", "tortik": "cake"});
  });

  test("remove in path", () {
    Map<String, dynamic> someMap = {
      "test": {"haha": "zhorik", "k1": "v1", "k2": "v2"},
      "k1": "123"
    };
    someMap.removeIn("test/haha");
    expect(someMap, {
      "test": {"k1": "v1", "k2": "v2"},
      "k1": "123",
    });
    someMap.removeIn("test/k1");
    expect(someMap, {
      "k1": "123",
      "test": {"k2": "v2"}
    });
    someMap.removeIn("k1");
    expect(someMap, {
      "test": {"k2": "v2"}
    });
  });

  test("find all paths in map", () {
    Map<String, dynamic> someMap = {"path": "value"};

    List<String> allPaths = someMap.findAllPaths();
    expect(allPaths, ["path"]);

    someMap = {
      "path": "value",
      "subPath": {"subVal": "value"}
    };
    allPaths = someMap.findAllPaths();

    expect(allPaths, ["path", "subPath", "subPath/subVal"]);
  });

  test("diff between two paths", () {
    Map<String, dynamic> map1 = {
      "path": "value",
      "deleted": "deleted",
      "unchanged": "unchanged"
    };
    Map<String, dynamic> map2 = {
      "path": "value1",
      "added": "added",
      "unchanged": "unchanged"
    };

    Map<String, dynamic> diffMap = map1.diff(map2);

    expect(diffMap, {
      "path": {"old": "value", "new": "value1"},
      "deleted": {"old": "deleted", "new": null},
      "added": {"old": null, "new": "added"},
    });
  });
}
