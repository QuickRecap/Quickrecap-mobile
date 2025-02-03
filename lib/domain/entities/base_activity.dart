class BaseActivity {
  int id;
  String name;
  int quantity;
  int timer;
  bool isRated;

  BaseActivity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.timer,
    required this.isRated,
  });
}