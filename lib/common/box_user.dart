import 'package:hive/hive.dart';

import '../model/user.dart';

class UserBox {
  static Box<UserModel> getUsers() => Hive.box('users');
}
