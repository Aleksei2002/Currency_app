import 'package:flutter/material.dart';

import '../models/exchange_rate.dart';
import '../services/currency_service.dart';
import 'currency_dropdown.dart';

class CurrencyApp extends StatefulWidget {
  @override
  State<CurrencyApp> createState() => _CurrencyAppState();
}

class _CurrencyAppState extends State<CurrencyApp> {
  String baseCurrency = 'EUR';
  String targetCurrency = 'USD';
  ExchangeRate? exchangeRate;

  Future<void> fetchExchangeRate() async {
    try {
      final rate = await CurrencyService.fetchExchangeRate(baseCurrency, targetCurrency);
      setState(() {
        exchangeRate = rate;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchExchangeRate();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = ['EUR', 'USD'];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Currency Converter'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: fetchExchangeRate,
            ),
          ],
        ),
        body: Padding(
        padding: const EdgeInsets.all(20.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    CurrencyDropdown(
    currencies: currencies,
    selectedCurrency: baseCurrency,
    onChanged: (value) => setState(() => baseCurrency = value
