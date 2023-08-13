class AmountModel {
  late final int id;
  late final String title;
  late final double amount;
  late final String createdAt;

  AmountModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.createdAt,
  });

  factory AmountModel.fromJson(Map<String, dynamic> json) {
    return AmountModel(
      id: json['id'],
      title: json['title'],
      amount: (json['amount'] * 100) / 100,
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'created_at': createdAt,
      };
}
