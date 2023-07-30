import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String profilePhotos;
  String email;
  String uid;

  User({
    required this.name,
    required this.profilePhotos,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'profilePhotos': profilePhotos,
        'email': email,
        'uid': uid,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      name: snapshot['name'],
      profilePhotos: snapshot['profilePhotos'],
      email: snapshot['email'],
      uid: snapshot['uid'],
    );
  }
}
