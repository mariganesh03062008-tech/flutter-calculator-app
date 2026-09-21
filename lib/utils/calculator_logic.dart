/// Utility class for parsing and evaluating arithmetic calculator expressions.
class CalculatorLogic {
  static const String divisionByZeroMsg = "Can't divide by 0";
  static const String errorMsg = "Error";

  /// Checks if a character is an operator.
  static bool isOperator(String char) {
    return char == '+' || char == '-' || char == '×' || char == '÷' || char == '%';
  }

  /// Checks if a character is an infix operator that expects a right operand.
  static bool isInfixOperator(String char) {
    return char == '+' || char == '-' || char == '×' || char == '÷';
  }

  /// Evaluates an expression string and returns the formatted result.
  /// Supported operators: +, -, ×, ÷, %
  static String evaluateExpression(String expression) {
    if (expression.trim().isEmpty) return '';

    // Sanitize string
    String cleanExp = expression.replaceAll(' ', '');

    // Trim trailing infix operators (+, -, ×, ÷) for live evaluation, keep postfix (%)
    while (cleanExp.isNotEmpty && isInfixOperator(cleanExp[cleanExp.length - 1])) {
      cleanExp = cleanExp.substring(0, cleanExp.length - 1);
    }

    if (cleanExp.isEmpty) return '';

    try {
      List<String> tokens = _tokenize(cleanExp);
      if (tokens.isEmpty) return '';

      // Check if ends with infix operator after tokenizing
      if (isInfixOperator(tokens.last)) {
        tokens.removeLast();
      }
      if (tokens.isEmpty) return '';

      double result = _evaluateTokens(tokens);
      if (result.isInfinite || result.isNaN) {
        return divisionByZeroMsg;
      }
      return _formatResult(result);
    } catch (e) {
      return errorMsg;
    }
  }

  /// Tokenizes the expression into numbers and operators.
  static List<String> _tokenize(String expression) {
    List<String> tokens = [];
    StringBuffer currentNumber = StringBuffer();

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (isOperator(char)) {
        // Handle negative numbers at start or after another operator
        if (char == '-' &&
            (tokens.isEmpty || isOperator(tokens.last)) &&
            currentNumber.isEmpty) {
          currentNumber.write(char);
          continue;
        }

        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber.toString());
          currentNumber.clear();
        }
        tokens.add(char);
      } else {
        currentNumber.write(char);
      }
    }

    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber.toString());
    }

    return tokens;
  }

  /// Evaluates list of tokens using operator precedence (BODMAS/PEMDAS).
  static double _evaluateTokens(List<String> tokens) {
    List<String> workingTokens = List.from(tokens);

    // 1st Pass: Handle Percentage (%)
    int i = 0;
    while (i < workingTokens.length) {
      if (workingTokens[i] == '%') {
        if (i == 0) throw Exception('Syntax error');
        double val = double.parse(workingTokens[i - 1]);
        double percentVal = val / 100.0;
        workingTokens[i - 1] = percentVal.toString();
        workingTokens.removeAt(i);
      } else {
        i++;
      }
    }

    // 2nd Pass: Handle Multiplications (×) and Divisions (÷)
    i = 0;
    while (i < workingTokens.length) {
      String token = workingTokens[i];
      if (token == '×' || token == '÷') {
        if (i == 0 || i >= workingTokens.length - 1) throw Exception('Syntax error');
        double left = double.parse(workingTokens[i - 1]);
        double right = double.parse(workingTokens[i + 1]);
        double stepResult;

        if (token == '×') {
          stepResult = left * right;
        } else {
          if (right == 0) return double.infinity;
          stepResult = left / right;
        }

        workingTokens[i - 1] = stepResult.toString();
        workingTokens.removeAt(i);     // remove operator
        workingTokens.removeAt(i);     // remove right operand
      } else {
        i++;
      }
    }

    // 3rd Pass: Handle Additions (+) and Subtractions (-)
    i = 0;
    while (i < workingTokens.length) {
      String token = workingTokens[i];
      if (token == '+' || token == '-') {
        if (i == 0 || i >= workingTokens.length - 1) throw Exception('Syntax error');
        double left = double.parse(workingTokens[i - 1]);
        double right = double.parse(workingTokens[i + 1]);
        double stepResult = (token == '+') ? (left + right) : (left - right);

        workingTokens[i - 1] = stepResult.toString();
        workingTokens.removeAt(i);     // remove operator
        workingTokens.removeAt(i);     // remove right operand
      } else {
        i++;
      }
    }

    if (workingTokens.length == 1) {
      return double.parse(workingTokens[0]);
    }

    throw Exception('Evaluation failed');
  }

  /// Formats the numerical result to remove unnecessary trailing decimals.
  static String _formatResult(double value) {
    if (value.isInfinite || value.isNaN) return divisionByZeroMsg;
    // Check if integer
    if (value == value.roundToDouble() && value.abs() < 1e12) {
      return value.toInt().toString();
    }
    // Limit decimal precision to 8 decimal places
    String str = value.toStringAsFixed(8);
    // Trim trailing zeroes and potential trailing decimal point
    if (str.contains('.')) {
      str = str.replaceAll(RegExp(r'0*$'), '');
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
      }
    }
    return str;
  }

  /// Appends a digit or decimal point safely.
  static String appendInput(String currentExp, String input) {
    if (currentExp.isEmpty) {
      if (input == '.') return '0.';
      if (isOperator(input) && input != '-') return '';
      return input;
    }

    String lastChar = currentExp[currentExp.length - 1];

    // If input is decimal
    if (input == '.') {
      // Find current active number token
      int lastOpIndex = -1;
      for (int i = currentExp.length - 1; i >= 0; i--) {
        if (isOperator(currentExp[i])) {
          lastOpIndex = i;
          break;
        }
      }
      String currentNumberToken = lastOpIndex == -1
          ? currentExp
          : currentExp.substring(lastOpIndex + 1);

      if (currentNumberToken.contains('.')) {
        return currentExp; // Disallow multiple decimals in same number
      }
      if (isOperator(lastChar)) {
        return '$currentExp 0.';
      }
      return '$currentExp.';
    }

    // If input is an operator
    if (isOperator(input)) {
      if (isOperator(lastChar)) {
        // Replace previous operator with the newly selected one
        return '${currentExp.substring(0, currentExp.length - 1)}$input';
      }
      return '$currentExp$input';
    }

    // If input is a digit
    return '$currentExp$input';
  }
}
