```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ø©',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6750A4),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double? _firstOperand;
  String? _operator;
  bool _isNewNumber = true;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isNewNumber) {
        _display = digit;
        _isNewNumber = false;
      } else {
        if (_display == '0' && digit != '.') {
          _display = digit;
        } else {
          _display += digit;
        }
      }
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_operator != null && !_isNewNumber) {
        _calculateResult();
      }
      _firstOperand = double.parse(_display);
      _operator = op;
      _expression = '$_firstOperand $op';
      _isNewNumber = true;
    });
  }

  void _onEqualsPressed() {
    setState(() {
      if (_operator != null && !_isNewNumber) {
        _calculateResult();
        _operator = null;
        _expression = '';
      }
    });
  }

  void _calculateResult() {
    final double secondOperand = double.parse(_display);
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand! * secondOperand;
        break;
      case 'Ã·':
        if (secondOperand != 0) {
          result = _firstOperand! / secondOperand;
        } else {
          _display = 'Ø®Ø·Ø£';
          _firstOperand = null;
          _operator = null;
          _isNewNumber = true;
          _expression = '';
          return;
        }
        break;
    }
    _display = result == result.truncateToDouble()
        ? result.toInt().toString()
        : result.toStringAsFixed(2);
    _firstOperand = result;
    _isNewNumber = true;
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _isNewNumber = true;
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (_isNewNumber) {
        _display = '0.';
        _isNewNumber = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onPercentagePressed() {
    setState(() {
      final double value = double.parse(_display) / 100;
      _display = value == value.truncateToDouble()
          ? value.toInt().toString()
          : value.toStringAsFixed(2);
    });
  }

  void _onPlusMinusPressed() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    double flex = 1,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      flex: flex.round(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 72,
          child: ElevatedButton(
            onPressed: onPressed ?? () => _onDigitPressed(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _expression,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _display,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Button grid
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  // Row 1: Clear, Plus/Minus, Percentage, Divide
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: 'C',
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                          onPressed: _onClearPressed,
                        ),
                        _buildButton(
                          text: 'Â±',
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                          onPressed: _onPlusMinusPressed,
                        ),
                        _buildButton(
                          text: '%',
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          textColor: Theme.of(context).colorScheme.onSecondaryContainer,
                          onPressed: _onPercentagePressed,
                        ),
                        _buildButton(
                          text: 'Ã·',
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () => _onOperatorPressed('Ã·'),
                        ),
                      ],
                    ),
                  ),
                  // Row 2: 7, 8, 9, Multiply
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: '7',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: '8',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: '9',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: 'Ã',
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () => _onOperatorPressed('Ã'),
                        ),
                      ],
                    ),
                  ),
                  // Row 3: 4, 5, 6, Minus
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: '4',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: '5',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: '6',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: '-',
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () => _onOperatorPressed('-'),
                        ),
                      ],
                    ),
                  ),
                  // Row 4: 1, 2, 3, Plus
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: '1',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: '2',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: '3',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        _buildButton(
                          text: '+',
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onPressed: () => _onOperatorPressed('+'),
                        ),
                      ],
                    ),
                  ),
                  // Row 5: 0 (double width), Decimal, Equals
                  Expanded(
                    child: Row(
                      children: [
                        _buildButton(
                          text: '0',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          flex: 2,
                        ),
                        _buildButton(
                          text: '.',
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          textColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          onPressed: _onDecimalPressed,
                        ),
                        _buildButton(
                          text: '=',
                          color: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          onPressed: _onEqualsPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```