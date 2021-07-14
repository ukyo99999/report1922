class Place {
  final int id;
  final String name;
  final String code;
  final int position;

  Place({
    required this.id,
    required this.name,
    required this.code,
    required this.position,
  });

  // Convert a Place into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'position': position,
    };
  }

  // Implement toString to make it easier to see information about
  // each place when using the print statement.
  @override
  String toString() {
    return 'Place{id: $id, name: $name, code: $code, position: $position}';
  }
}
