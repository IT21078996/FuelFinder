// create a user with UID

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePictureUrl;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      required this.profilePictureUrl});
}
