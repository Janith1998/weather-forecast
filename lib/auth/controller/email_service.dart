import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class EmailService {
//   static const _keyLastEmail = 'last_email';
//   final BehaviorSubject<String> _emailSubject = BehaviorSubject.seeded('');

//   Stream<String> get emailStream => _emailSubject.stream;
//   String get currentEmail => _emailSubject.value;

//   Future<void> init() async {
//     final prefs = await SharedPreferences.getInstance();
//     final lastEmail = prefs.getString(_keyLastEmail) ?? '';
//     _emailSubject.add(lastEmail); // Start the stream with saved email
//   }

//   void updateEmail(String email) async {
//     _emailSubject.add(email); // Add the new email to the stream
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyLastEmail, email); // Save it to SharedPreferences
//   }

//   void dispose() {
//     _emailSubject.close();
//   }
// }

class EmailService {
  static const _keyLastEmail = 'last_email';
  final BehaviorSubject<String> _emailSubject = BehaviorSubject.seeded('');

  Stream<String> get emailStream => _emailSubject.stream;
  String get currentEmail => _emailSubject.value;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final lastEmail = prefs.getString(_keyLastEmail) ?? '';
    _emailSubject.add(lastEmail);
  }

  void updateEmail(String email) async {
    _emailSubject.add(email);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastEmail, email);
  }

  void clearEmail() async {
    _emailSubject.add('');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLastEmail);
  }

  void dispose() {
    _emailSubject.close();
  }
}
