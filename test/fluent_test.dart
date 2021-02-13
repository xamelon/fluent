import 'package:flutter_test/flutter_test.dart';

import 'package:fluent/fluent.dart';

void main() {
  test("Add event effect", () {
    Fluent.fluent.state.addIn("DeliveryPayment/User/SecondName", "Tortik");

    Fluent.regEffect("DeliveryPayment/User/NameChanged", (state,
        [firstName, lastName]) {
      // expect(state.getIn("DeliveryPayment/User/SecondName"), "Tortik");
      expect(firstName, "Anton");
      expect(lastName, "Buldakov");
      return state
        ..addIn("DeliveryPayment/User",
            {"LastName": lastName, "FirstName": firstName});
    });

    Fluent.regEffect("DeliveryPayment/User/SecondNameRemove", (state, [_]) {
      print("state in effect: $state");
      return state..removeIn("DeliveryPayment/User/SecondName");
    });

    Stream userSub = Fluent.regSub("DeliveryPayment/User");

    expectLater(
        userSub,
        emitsInOrder([
          {
            "FirstName": "Anton",
            "LastName": "Buldakov",
            "SecondName": "Tortik"
          },
          {"FirstName": "Anton", "LastName": "Buldakov"}
        ]));

    Fluent.dispatch("DeliveryPayment/User/NameChanged", ["Anton", "Buldakov"]);
    Fluent.dispatch("DeliveryPayment/User/SecondNameRemove", []);
  });

  test("test stream with new vals", () async {
    Fluent.regEffect("Login/UsernameChanged", (state, [username]) {
      return state..addIn("Login/Username", username);
    });

    Stream usernameSub = Fluent.regSub("Login/Username");
    expectLater(
        usernameSub, emitsInOrder(["xamelon", "xamelon96", "stasbuldakov"]));

    Fluent.dispatch("Login/UsernameChanged", ["xamelon"]);
    Fluent.dispatch("Login/UsernameChanged", ["xamelon96"]);
    Fluent.dispatch("Login/UsernameChanged", ["stasbuldakov"]);
  });

  test("async effects", () {
    Fluent.regEffect("Login/UsernameChanged", (state, [username]) async {
      await Future.delayed(Duration(seconds: 1));
      return state..addIn("Login/Username", username);
    });

    expectLater(Fluent.regSub("Login/Username"), emitsInOrder(["xamelon"]));

    Fluent.dispatch("Login/UsernameChanged", ["xamelon"]);
  });
}
