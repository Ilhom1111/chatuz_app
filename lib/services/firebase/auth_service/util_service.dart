sealed class Util {
  static bool validateRegistration(
      String username, String email, String password, String prePassword) {
    return username.isNotEmpty &&
        RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
            .hasMatch(email) &&
        password.length >= 6 &&
        password == prePassword;
  }

  static bool validateSingIn(String email, String password) {
    return RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
            .hasMatch(email) &&
        password.length >= 6;
  }
}
