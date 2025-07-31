import 'package:flutter/material.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String sourceCurrency = 'USD';
  String targetCurrency = 'EUR';
  final TextEditingController textEditingController = TextEditingController();
  
  // Exchange rates: amount of USD per unit of currency
  static const Map<String, double> rates = {
    'USD': 1.0,
    'EUR': 1.18,
    'GBP': 1.38,
    'JPY': 0.0091,
    'INR': 0.012,
  };

  double _calculateResult(String input) {
    double amount = double.tryParse(input) ?? 0;
    return amount * (rates[sourceCurrency]! / rates[targetCurrency]!);
  }

  void _swapCurrencies() {
    setState(() {
      final temp = sourceCurrency;
      sourceCurrency = targetCurrency;
      targetCurrency = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    double result = _calculateResult(textEditingController.text);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input Section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount in $sourceCurrency',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                _buildCurrencyDropdown(
                  value: sourceCurrency,
                  onChanged: (newValue) {
                    setState(() => sourceCurrency = newValue!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Swap Button
            IconButton(
              icon: const Icon(Icons.swap_vert, size: 32),
              color: Theme.of(context).primaryColor,
              onPressed: _swapCurrencies,
            ),
            const SizedBox(height: 20),
            // Result Section
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        result.toStringAsFixed(2),
                        key: ValueKey(result),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildCurrencyDropdown(
                  value: targetCurrency,
                  onChanged: (newValue) {
                    setState(() => targetCurrency = newValue!);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      items: rates.keys.map((currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList(),
      onChanged: onChanged,
      underline: const SizedBox(),
      style: const TextStyle(
        fontSize: 18,
        color: Colors.black87,
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }
}