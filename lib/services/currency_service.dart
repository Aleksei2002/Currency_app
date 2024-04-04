import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/exchange_rate.dart';

class CurrencyService {
  static Future<ExchangeRate> fetchExchangeRate(String base, String target) async {
    final url = Uri.parse('https://freecurrencyapi.com/api/v1/rates?base=$base&symbols=$target');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rates = data['rates'];
      final rate = rates[target];
      return ExchangeRate(base, target, rate);
    } else {
      throw Exception('Failed to fetch exchange rate');
    }
  }
}
