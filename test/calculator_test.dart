import 'package:flutter_test/flutter_test.dart';
import '../lib/utils/calculator_logic.dart';

void main() {
  group('CalculatorLogic Unit Tests', () {
    test('Basic Addition', () {
      expect(CalculatorLogic.evaluateExpression('12+8'), equals('20'));
      expect(CalculatorLogic.evaluateExpression('0.1+0.2'), equals('0.3'));
    });

    test('Basic Subtraction', () {
      expect(CalculatorLogic.evaluateExpression('25-10'), equals('15'));
      expect(CalculatorLogic.evaluateExpression('10-25'), equals('-15'));
    });

    test('Basic Multiplication', () {
      expect(CalculatorLogic.evaluateExpression('7×8'), equals('56'));
      expect(CalculatorLogic.evaluateExpression('2.5×4'), equals('10'));
    });

    test('Basic Division', () {
      expect(CalculatorLogic.evaluateExpression('100÷4'), equals('25'));
      expect(CalculatorLogic.evaluateExpression('5÷2'), equals('2.5'));
    });

    test('Division by Zero Handling', () {
      expect(CalculatorLogic.evaluateExpression('10÷0'), equals("Can't divide by 0"));
    });

    test('Operator Precedence (BODMAS)', () {
      // 2 + 3 * 4 should be 14, not 20
      expect(CalculatorLogic.evaluateExpression('2+3×4'), equals('14'));
      // 20 - 10 / 2 should be 15
      expect(CalculatorLogic.evaluateExpression('20-10÷2'), equals('15'));
    });

    test('Percentage Operation', () {
      expect(CalculatorLogic.evaluateExpression('50%'), equals('0.5'));
      expect(CalculatorLogic.evaluateExpression('200×10%'), equals('20'));
    });

    test('Append Input Validation', () {
      // Decimal prevention in same number
      String exp = '12.5';
      exp = CalculatorLogic.appendInput(exp, '.');
      expect(exp, equals('12.5'));

      // Replacing operator
      exp = '12+';
      exp = CalculatorLogic.appendInput(exp, '×');
      expect(exp, equals('12×'));

      // Adding decimals to fresh expression
      expect(CalculatorLogic.appendInput('', '.'), equals('0.'));
    });
  });
}
