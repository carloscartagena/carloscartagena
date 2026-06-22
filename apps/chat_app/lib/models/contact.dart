class Contact {
  final int? id;
  final String name;
  final String phone;
  final String avatarColor; // hex color string, e.g. "FF6750A4"
  final String status;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    this.avatarColor = 'FF6750A4',
    this.status = 'Disponible',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'avatar_color': avatarColor,
      'status': status,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      name: map['name'] as String,
      phone: map['phone'] as String,
      avatarColor: map['avatar_color'] as String? ?? 'FF6750A4',
      status: map['status'] as String? ?? 'Disponible',
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
        .toUpperCase();
  }
}
