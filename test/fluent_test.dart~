import 'package:flutter_test/flutter_test.dart';

import 'package:fluent/fluent.dart';
import 'package:fluent/map.dart';

void main() {
  test("Add event effect", () {
    Fluent fluent = new Fluent();

    fluent.state.addIn("DeliveryPayment/User/Name", "Stas");

    fluent.regEffect(
        "DeliveryPayment/User/NameChanged", ["DeliveryPayment/User/Name"], (
            [oldLastName, firstName, lastName]) {
      expect(oldLastName, "Stas");
      return {}..addIn("DeliveryPayment/User/Name", firstName);
    });

    expect(hehe.effects.containsKey("DeliveryPayment/User/NameChanged"), true);

    fluent.dispatch("DeliveryPayment/User/NameChanged", ["Anton", "Buldakov"]);
    expect(hehe.state.getIn("DeliveryPayment/User/Name"), "Anton");
  });
}
