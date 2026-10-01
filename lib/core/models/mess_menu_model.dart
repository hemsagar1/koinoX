class MessMenuModel {
  final String day;
  final String breakfast;
  final String lunch;
  final String snacks;
  final String dinner;
  final double rating;

  const MessMenuModel({
    required this.day,
    required this.breakfast,
    required this.lunch,
    required this.snacks,
    required this.dinner,
    this.rating = 4.2,
  });
}
