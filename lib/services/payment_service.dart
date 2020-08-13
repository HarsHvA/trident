import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  String amount;
  String purpose;
  String name;
  String email;
  var context;

  PaymentService(
      {@required this.amount,
      @required this.purpose,
      @required this.name,
      @required this.email,
      @required this.context});

  Future<String> createRequest() async {
    Map<String, String> body = {
      "amount": amount,
      "purpose": purpose,
      "buyer_name": name,
      "email": email,
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "https://www.iceagedev.com/redirect",
    };
    var resp = await http.post(
        Uri.encodeFull("https://www.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "2451e1523b32cf3e809fd0a49ecf009b",
          "X-Auth-Token": "7566dcde2ea581004623c54d1b54857f"
        },
        body: body);
    print(json.decode(resp.body));
    if (json.decode(resp.body)['success'] == true) {
      String selectedUrl =
          json.decode(resp.body)["payment_request"]["longurl"].toString() +
              "?embed=form";

      return selectedUrl;
    } else {
      return null;
    }
  }
}
