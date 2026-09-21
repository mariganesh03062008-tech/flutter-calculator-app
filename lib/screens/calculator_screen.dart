import 'package:flutter/material.dart';
import '../utils/calculator_logic.dart';
import '../widgets/calc_button.dart';

class CalculatorScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const CalculatorScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _previewResult = '';
  final ScrollController _scrollController = ScrollController();

  void _onDigitPress(String digit) {
    setState(() {
      _expression = CalculatorLogic.appendInput(_expression, digit);
      _updatePreview();
    });
    _scrollToEnd();
  }

  void _onOperatorPress(String op) {
    if (_expression.isEmpty && op != '-') return;
    setState(() {
      _expression = CalculatorLogic.appendInput(_expression, op);
      _updatePreview();
    });
    _scrollToEnd();
  }

  void _onClear() {
    setState(() {
      _expression = '';
      _previewResult = '';
    });
  }

  void _onBackspace() {
    if (_expression.isNotEmpty) {
      setState(() {
        _expression = _expression.substring(0, _expression.length - 1);
        _updatePreview();
      });
    }
  }

  void _onEquals() {
    if (_expression.isEmpty) return;

    final result = CalculatorLogic.evaluateExpression(_expression);
    setState(() {
      if (result == CalculatorLogic.divisionByZeroMsg ||
          result == CalculatorLogic.errorMsg) {
        _previewResult = result;
      } else {
        _expression = result;
        _previewResult = '';
      }
    });
    _scrollToEnd();
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _previewResult = '';
      return;
    }
    final result = CalculatorLogic.evaluateExpression(_expression);
    if (result != CalculatorLogic.divisionByZeroMsg &&
        result != CalculatorLogic.errorMsg &&
        result != _expression) {
      _previewResult = result;
    } else {
      _previewResult = '';
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Display Area
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Expression input with horizontal scroll
                    SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _expression.isEmpty ? '0' : _expression,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w400,
                          color: _expression.isEmpty
                              ? (isDark ? Colors.white38 : Colors.black38)
                              : (isDark ? Colors.white : Colors.black87),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Live calculation preview
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: _previewResult.isNotEmpty ? 1.0 : 0.0,
                      child: Text(
                        _previewResult.isNotEmpty ? '= $_previewResult' : '',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF64D2FF) : const Color(0xFF007AFF),
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1, thickness: 0.8),
            const SizedBox(height: 8),

            // Keypad Grid (4 columns x 5 rows)
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Column(
                  children: [
                    // Row 1: AC, ⌫, %, ÷
                    Expanded(
                      child: Row(
                        children: [
                          CalcButton(
                            label: 'AC',
                            type: ButtonType.action,
                            onTap: _onClear,
                          ),
                          CalcButton(
                            label: '⌫',
                            icon: Icons.backspace_outlined,
                            type: ButtonType.action,
                            onTap: _onBackspace,
                          ),
                          CalcButton(
                            label: '%',
                            type: ButtonType.action,
                            onTap: () => _onOperatorPress('%'),
                          ),
                          CalcButton(
                            label: '÷',
                            type: ButtonType.operator,
                            onTap: () => _onOperatorPress('÷'),
                          ),
                        ],
                      ),
                    ),
                    // Row 2: 7, 8, 9, ×
                    Expanded(
                      child: Row(
                        children: [
                          CalcButton(label: '7', onTap: () => _onDigitPress('7')),
                          CalcButton(label: '8', onTap: () => _onDigitPress('8')),
                          CalcButton(label: '9', onTap: () => _onDigitPress('9')),
                          CalcButton(
                            label: '×',
                            type: ButtonType.operator,
                            onTap: () => _onOperatorPress('×'),
                          ),
                        ],
                      ),
                    ),
                    // Row 3: 4, 5, 6, -
                    Expanded(
                      child: Row(
                        children: [
                          CalcButton(label: '4', onTap: () => _onDigitPress('4')),
                          CalcButton(label: '5', onTap: () => _onDigitPress('5')),
                          CalcButton(label: '6', onTap: () => _onDigitPress('6')),
                          CalcButton(
                            label: '-',
                            type: ButtonType.operator,
                            onTap: () => _onOperatorPress('-'),
                          ),
                        ],
                      ),
                    ),
                    // Row 4: 1, 2, 3, +
                    Expanded(
                      child: Row(
                        children: [
                          CalcButton(label: '1', onTap: () => _onDigitPress('1')),
                          CalcButton(label: '2', onTap: () => _onDigitPress('2')),
                          CalcButton(label: '3', onTap: () => _onDigitPress('3')),
                          CalcButton(
                            label: '+',
                            type: ButtonType.operator,
                            onTap: () => _onOperatorPress('+'),
                          ),
                        ],
                      ),
                    ),
                    // Row 5: 00, 0, ., =
                    Expanded(
                      child: Row(
                        children: [
                          CalcButton(label: '00', onTap: () => _onDigitPress('00')),
                          CalcButton(label: '0', onTap: () => _onDigitPress('0')),
                          CalcButton(label: '.', onTap: () => _onDigitPress('.')),
                          CalcButton(
                            label: '=',
                            type: ButtonType.equals,
                            onTap: _onEquals,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
