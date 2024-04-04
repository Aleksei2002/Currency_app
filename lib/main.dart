import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/exchange_rate.dart';
import 'services/currency_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CurrencyConverterPage(),
    );
  }
}

class CurrencyConverterPage extends StatefulWidget {
  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _baseCurrencyController = TextEditingController();
  final TextEditingController _targetCurrencyController = TextEditingController();

  String _errorMessage = '';
  ExchangeRate? _exchangeRate;

  Future<void> _fetchExchangeRate() async {
    try {
      final String base = _baseCurrencyController.text.trim().toUpperCase();
      final String target = _targetCurrencyController.text.trim().toUpperCase();

      if (base.isEmpty || target.isEmpty) {
        setState(() {
          _errorMessage = 'Please enter valid currency codes.';
        });
        return;
      }

      final ExchangeRate rate = await CurrencyService.fetchExchangeRate(base, target);

      setState(() {
        _exchangeRate = rate;
        _errorMessage = '';
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: ${error.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Currency Converter'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchExchangeRate,
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Row(
            children: [
            Expanded(
            child: TextField(
              controller: _baseCurrencyController,
              decoration: InputDecoration(
                labelText: 'Base Currency',
                border: const OutlineInputBorder(),
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: TextField(
              controller: _targetCurrencyController,
              decoration: const InputDecoration(
                labelText: 'Target Currency',
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          ],
        ),
        const SizedBox(height: 20.0),
        if (_exchangeRate != null) {
      final double? baseValue = double.tryParse(_baseCurrencyController.text);
      final double? rateValue = _exchangeRate!.rate;

      if (baseValue != null && rateValue != null) {
        final double targetValue = baseValue * rateValue;

        return Text(
          '${_baseCurrencyController.text} 1 = ${_targetCurrencyController.text} ${targetValue.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 24.0),
        );
      }
    }
    ],
    ),
    ),
    ),
    );
    }
}
