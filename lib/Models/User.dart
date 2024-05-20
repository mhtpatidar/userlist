// lib/models/user.dart
class User {
  final String name;
  final String email;
  final String country;
  final DateTime registrationDate;
  final DateTime dob;
  final String pictureUrl;
  final String city;
  final String state;
  final String postcode;

  User({
    required this.name,
    required this.email,
    required this.country,
    required this.registrationDate,
    required this.dob,
    required this.pictureUrl,
    required this.city,
    required this.state,
    required this.postcode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: "${json['name']['first']} ${json['name']['last']}",
      email: json['email'],
      country: json['location']['country'],
      registrationDate: DateTime.parse(json['registered']['date']),
      dob: DateTime.parse(json['dob']['date']),
      pictureUrl: json['picture']['large'],
      city: json['location']['city'],
      state: json['location']['state'],
      postcode: json['location']['postcode'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'country': country,
      'registrationDate': registrationDate.toIso8601String(),
      'dob': dob.toIso8601String(),
      'pictureUrl': pictureUrl,
      'city': city,
      'state': state,
      'postcode': postcode,
    };
  }
}
