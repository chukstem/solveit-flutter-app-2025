import 'package:bcrypt/bcrypt.dart';

String hashPassword(String password) {
  return BCrypt.hashpw(password, BCrypt.gensalt());
}

bool verifyPassword(String password, String hashedPassword) {
  return BCrypt.checkpw(password, hashedPassword);
}

// void main() {
//   String password = "MySecurePassword";
//   String hashedPassword = hashPassword(password);

//   print("Hashed Password: $hashedPassword");

//   // Verify the password
//   bool isValid = verifyPassword("MySecurePassword", hashedPassword);
//   print("Password is valid: $isValid");
// }
