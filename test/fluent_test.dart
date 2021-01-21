import 'package:flutter_test/flutter_test.dart';

import 'package:fluent/fluent.dart';

void main() {
  test("Add event effect", () {
      Fluent.fluent.state.addIn("DeliveryPayment/User/SecondName", "Tortik");
      
      Fluent.regEffect("DeliveryPayment/User/NameChanged",
        (state, [firstName, lastName]) {
          // expect(state.getIn("DeliveryPayment/User/SecondName"), "Tortik");
          expect(firstName, "Anton");
          expect(lastName, "Buldakov");
          return state..addIn("DeliveryPayment/User", {"LastName": lastName, "FirstName": firstName});
      });

      Fluent.regEffect("DeliveryPayment/User/SecondNameRemove",
        (state, [haha, hah, h]) {
          return state..removeIn("DeliveryPayment/User/SecondName");
      });

      Fluent.dispatch("DeliveryPayment/User/NameChanged", ["Anton", "Buldakov"]);
      expect(Fluent.fluent.state.getIn("DeliveryPayment/User/FirstName"), "Anton");
      expect(Fluent.fluent.state.getIn("DeliveryPayment/User/LastName"), "Buldakov");
      expect(Fluent.fluent.state.getIn("DeliveryPayment/User/SecondName"), "Tortik");

      Fluent.dispatch("DeliveryPayment/User/SecondNameRemove", []);
      expect(Fluent.fluent.state.getIn("DeliveryPayment/User/SecondName"), null);
  });

  test("test stream with new vals", () async {
    Fluent.fluent.state.addIn("Login/Username", "xamelon");

    Fluent.regEffect("Login/UsernameChanged", (state, [username]) {
      return state..addIn("Login/Username", username);
    });

    Stream usernameSub = Fluent.regSub("Login/Username");
    expectLater(usernameSub, emitsInOrder(["xamelon", "xamelon96"]));

    Fluent.dispatch("Login/UsernameChanged", ["xamelon"]);
    Fluent.dispatch("Login/UsernameChanged", ["xamelon96"]);
  });
}
