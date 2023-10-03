class FirebaseUser {
  final String? uid;
  final String? code;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoURL;

  FirebaseUser({
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoURL,
    this.uid,
    this.code,
  });
}
