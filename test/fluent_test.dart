import 'package:flutter_test/flutter_test.dart';

import 'package:fluent/fluent.dart';

void main() {
  test("Add event effect", () {
    Fluent fluent = new Fluent();

    fluent.state.addIn("DeliveryPayment/User/Name", "Stas");

    fluent.regEffect(
      "DeliveryPayment/User/NameChanged",
      ["DeliveryPayment/User/Name"],
      ([oldLastName, firstName, lastName]) {
      expect(oldLastName, "Stas");
      return {}..addIn("DeliveryPayment/User/Name", firstName);
    });

    expect(fluent.effects.containsKey("DeliveryPayment/User/NameChanged"), true);

    fluent.dispatch("DeliveryPayment/User/NameChanged", ["Anton", "Buldakov"]);
    expect(fluent.state.getIn("DeliveryPayment/User/Name"), "Anton");
});

test("test stream with new vals", () async {
    Fluent fluent = new Fluent();

    fluent.state.addIn("Login/Username", "xamelon");

    fluent.regEffect(
      "Login/UsernameChanged",
      [],
      ([username]) {
        return {}..addIn("Login/Username", username);
    });

    Stream usernameSub = fluent.regSub("Login/Username");
    expectLater(usernameSub, emitsInOrder(["xamelon", "xamelon96"]));
    
    fluent.dispatch("Login/UsernameChanged", ["xamelon"]);
    fluent.dispatch("Login/UsernameChanged", ["xamelon96"]);
});
}
