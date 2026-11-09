class Dhikr {
  final String text;
  final int count;
  final String? virtue;
  const Dhikr({required this.text, required this.count, this.virtue});
}

class AdhkarSession {
  final String title;
  final List<Dhikr> items;
  const AdhkarSession({required this.title, required this.items});
}
