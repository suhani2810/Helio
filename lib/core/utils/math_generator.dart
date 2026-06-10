import 'dart:math';

class MathQuestion {
  final String expression;
  final String answer;

  MathQuestion({required this.expression, required this.answer});
}

class MathGenerator {
  static final _random = Random();

  static MathQuestion generate(int difficulty) {
    if (difficulty == 0) {
      // Easy: Addition, Subtraction, Numbers between 1-20
      return _generateEasy();
    } else if (difficulty == 1) {
      // Medium: Addition, Subtraction, Multiplication, Division, Numbers between 10-100
      return _generateMedium();
    } else {
      // Hard: Multi-step expressions, Parentheses, Multiplication and Division combinations
      return _generateHard();
    }
  }

  static MathQuestion _generateEasy() {
    final isAddition = _random.nextBool();
    final a = _random.nextInt(20) + 1; // 1-20
    final b = _random.nextInt(20) + 1; // 1-20
    if (isAddition) {
      return MathQuestion(
        expression: '$a + $b',
        answer: '${a + b}',
      );
    } else {
      final val1 = max(a, b);
      final val2 = min(a, b);
      return MathQuestion(
        expression: '$val1 - $val2',
        answer: '${val1 - val2}',
      );
    }
  }

  static MathQuestion _generateMedium() {
    final type = _random.nextInt(3); // 0: +, 1: -, 2: *
    if (type == 0) {
      // Addition: Numbers 1-100
      final a = _random.nextInt(100) + 1; // 1-100
      final b = _random.nextInt(100) + 1; // 1-100
      return MathQuestion(
        expression: '$a + $b',
        answer: '${a + b}',
      );
    } else if (type == 1) {
      // Subtraction: Numbers 1-100
      final a = _random.nextInt(100) + 1; // 1-100
      final b = _random.nextInt(100) + 1; // 1-100
      final val1 = max(a, b);
      final val2 = min(a, b) == val1 ? (val1 > 1 ? val1 - 1 : 1) : min(a, b);
      return MathQuestion(
        expression: '$val1 - $val2',
        answer: '${val1 - val2}',
      );
    } else {
      // Multiplication: Numbers 1-100, e.g. 24 x 3
      final a = _random.nextInt(91) + 10; // 10-100
      final b = _random.nextInt(8) + 2; // 2-9
      final isFirstDouble = _random.nextBool();
      return MathQuestion(
        expression: isFirstDouble ? '$a × $b' : '$b × $a',
        answer: '${a * b}',
      );
    }
  }

  static MathQuestion _generateHard() {
    final format = _random.nextInt(4);
    switch (format) {
      case 0:
        // (a × b) ± c
        final a = _random.nextInt(15) + 5; // 5-19
        final b = _random.nextInt(8) + 3;  // 3-10
        final isPlus = _random.nextBool();
        final prod = a * b;
        if (isPlus) {
          final c = _random.nextInt(50) + 10; // 10-59
          return MathQuestion(
            expression: '($a × $b) + $c',
            answer: '${prod + c}',
          );
        } else {
          final c = _random.nextInt(prod - 5) + 1;
          return MathQuestion(
            expression: '($a × $b) - $c',
            answer: '${prod - c}',
          );
        }
      case 1:
        // (a ÷ b) ± c
        final b = _random.nextInt(8) + 3; // 3-10
        final divResult = _random.nextInt(20) + 5; // 5-24
        final a = divResult * b;
        final isPlus = _random.nextBool();
        if (isPlus) {
          final c = _random.nextInt(50) + 10;
          return MathQuestion(
            expression: '($a ÷ $b) + $c',
            answer: '${divResult + c}',
          );
        } else {
          final c = _random.nextInt(divResult - 2) + 1;
          return MathQuestion(
            expression: '($a ÷ $b) - $c',
            answer: '${divResult - c}',
          );
        }
      case 2:
        // a ± (b × c)
        final b = _random.nextInt(10) + 3; // 3-12
        final c = _random.nextInt(8) + 3;  // 3-10
        final prod = b * c;
        final isPlus = _random.nextBool();
        if (isPlus) {
          final a = _random.nextInt(50) + 10;
          return MathQuestion(
            expression: '$a + ($b × $c)',
            answer: '${a + prod}',
          );
        } else {
          final a = prod + _random.nextInt(50) + 5;
          return MathQuestion(
            expression: '$a - ($b × $c)',
            answer: '${a - prod}',
          );
        }
      case 3:
      default:
        // a ± (b ÷ c)
        final c = _random.nextInt(8) + 3; // 3-10
        final divResult = _random.nextInt(15) + 5; // 5-19
        final b = divResult * c;
        final isPlus = _random.nextBool();
        if (isPlus) {
          final a = _random.nextInt(50) + 10;
          return MathQuestion(
            expression: '$a + ($b ÷ $c)',
            answer: '${a + divResult}',
          );
        } else {
          final a = divResult + _random.nextInt(50) + 5;
          return MathQuestion(
            expression: '$a - ($b ÷ $c)',
            answer: '${a - divResult}',
          );
        }
    }
  }
}
