class TrustedContact {
  const TrustedContact({
    required this.id,
    required this.fullName,
    this.relationship,
    this.phone,
    this.whatsapp,
    this.email,
  });

  final String id;
  final String fullName;
  final String? relationship;
  final String? phone;
  final String? whatsapp;
  final String? email;

  factory TrustedContact.fromMap(Map<String, dynamic> map) {
    return TrustedContact(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      relationship: map['relationship'] as String?,
      phone: map['phone'] as String?,
      whatsapp: map['whatsapp'] as String?,
      email: map['email'] as String?,
    );
  }
}
