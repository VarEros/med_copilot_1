class Credentials {
  int userId;
  String accessToken;

  Credentials({
    required this.userId,
    required this.accessToken
  });

  factory Credentials.fromJson(Map<String, dynamic> json) {
    return Credentials(
      userId: json['user_id'], 
      accessToken: json['access_token']
      );
  }
}