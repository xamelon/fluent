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
  });

  test("remove in path", () {
      Map<String, dynamic> someMap = {
        "test": {
          "haha": "zhorik",
          "k1": "v1",
        },
        "k1": "123"
      };
      someMap.removeIn("test/haha");
      expect(someMap, {
          "test": {"k1": "v1"},
          "k1": "123",
      });
      someMap.removeIn("test/k1");
      expect(someMap, {"k1": "123"});
      someMap.removeIn("k1");
      expect(someMap, {});
  });

  test("find all paths in map", () {
      Map<String, dynamic> someMap = {"path": "value"};

      List<String> allPaths = someMap.findAllPaths();
      expect(allPaths, ["path"]);

      someMap = {"path": "value", "subPath": {"subVal": "value"}};
      allPaths = someMap.findAllPaths();
      
      expect(allPaths, ["path", "subPath", "subPath/subVal"]);
  });
}
