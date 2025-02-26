import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' My Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({Key? key}) : super(key: key);

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _displayText = "0";
  String _currentNumber = "";
  String _firstOperand = "";
  String _operator = "";
  bool _shouldResetDisplay = false;

  void _onNumberPressed(String number) {
    setState(() {
      if (_shouldResetDisplay) {
        _currentNumber = number;
        _shouldResetDisplay = false;
      } else {
        if (_currentNumber == "0") {
          _currentNumber = number;
        } else {
          _currentNumber += number;
        }
      }
      _displayText = _currentNumber;
    });
  }

  void _onDecimalPressed() {
    setState(() {
      if (!_currentNumber.contains(".")) {
        if (_shouldResetDisplay || _currentNumber.isEmpty) {
          _currentNumber = "0.";
          _shouldResetDisplay = false;
        } else {
          _currentNumber += ".";
        }
      }
      _displayText = _currentNumber;
    });
  }

  void _onOperatorPressed(String operator) {
    if (_firstOperand.isNotEmpty &&
        _operator.isNotEmpty &&
        _currentNumber.isNotEmpty) {
      _calculateResult();
    }
    setState(() {
      _firstOperand = _currentNumber.isEmpty ? _displayText : _currentNumber;
      _operator = operator;
      _shouldResetDisplay = true;
    });
  }

  void _onEqualsPressed() {
    if (_firstOperand.isNotEmpty &&
        _operator.isNotEmpty &&
        _currentNumber.isNotEmpty) {
      _calculateResult();
    }
  }

  void _calculateResult() {
    double first = double.tryParse(_firstOperand) ?? 0;
    double second = double.tryParse(_currentNumber) ?? 0;
    double result = 0;

    setState(() {
      if (_operator == "÷" && second == 0) {
        _displayText = "Error";
        return;
      }

      switch (_operator) {
        case "+":
          result = first + second;
          break;
        case "-":
          result = first - second;
          break;
        case "×":
          result = first * second;
          break;
        case "÷":
          result = first / second;
          break;
      }
      _displayText = result.toString();
      _firstOperand = _displayText;
      _currentNumber = "";
      _operator = "";
      _shouldResetDisplay = true;
    });
  }

  Widget _buildButton(String text, Color backgroundColor, Color textColor,
      Function() onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 24.0, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color operatorColor = Colors.orange;
    final Color numberColor = Colors.grey.shade800;
    final Color textColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
          title: const Text('My Calculator App'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _displayText,
                style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton("7", numberColor, textColor,
                        () => _onNumberPressed("7")),
                    _buildButton("8", numberColor, textColor,
                        () => _onNumberPressed("8")),
                    _buildButton("9", numberColor, textColor,
                        () => _onNumberPressed("9")),
                    _buildButton("÷", operatorColor, textColor,
                        () => _onOperatorPressed("÷")),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4", numberColor, textColor,
                        () => _onNumberPressed("4")),
                    _buildButton("5", numberColor, textColor,
                        () => _onNumberPressed("5")),
                    _buildButton("6", numberColor, textColor,
                        () => _onNumberPressed("6")),
                    _buildButton("×", operatorColor, textColor,
                        () => _onOperatorPressed("×")),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("1", numberColor, textColor,
                        () => _onNumberPressed("1")),
                    _buildButton("2", numberColor, textColor,
                        () => _onNumberPressed("2")),
                    _buildButton("3", numberColor, textColor,
                        () => _onNumberPressed("3")),
                    _buildButton("-", operatorColor, textColor,
                        () => _onOperatorPressed("-")),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("0", numberColor, textColor,
                        () => _onNumberPressed("0")),
                    _buildButton(
                        ".", numberColor, textColor, () => _onDecimalPressed()),
                    _buildButton("=", operatorColor, textColor,
                        () => _onEqualsPressed()),
                    _buildButton("+", operatorColor, textColor,
                        () => _onOperatorPressed("+")),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
