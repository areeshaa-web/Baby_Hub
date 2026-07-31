class PaymentModel {
  const PaymentModel({
    required this.method,
    required this.status,
    this.cardLast4,
  });

  final String method;
  final String status;
  final String? cardLast4;

  String get displayText {
    if (cardLast4 != null && cardLast4!.isNotEmpty) {
      return '$method •••• $cardLast4';
    }
    return method;
  }
}
