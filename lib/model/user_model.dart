import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String gender;
  final DateTime birthdate;

  const User({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    required this.gender,
    required this.birthdate,
  });

  Map<String, dynamic> tojson() => {
        'uid': uid,
        'name': name,
        'username': username,
        'email': email,
        'gender': gender,
        'birthdate': birthdate,
      };

  Map<String, String> tojsonString() => {
        'uid': uid,
        'name': name,
        'username': username,
        'email': email,
        'gender': gender,
        'birthdate': birthdate.toString(),
      };

  static User fromSpan(DocumentSnapshot snap) {
    var snapshot = (snap.data()) as Map<String, dynamic>;

    //FIXME Why snapshot['birthdate'] is timestamp should we convert all to timestamp?
    return User(
      uid: snapshot['uid'],
      name: snapshot['name'],
      username: snapshot['username'],
      email: snapshot['email'],
      birthdate: (snapshot['birthdate'] as Timestamp).toDate(),
      gender: snapshot['gender'],
    );
  }
}
