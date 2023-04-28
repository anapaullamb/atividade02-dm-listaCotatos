import 'package:contact_crud_hive/home_contact.dart';
import 'package:contact_crud_hive/model/user.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  /** Registra o Adapter */
  Hive.registerAdapter(UserModelAdapter());
  /** Abre um Box tipado */
  await Hive.openBox<UserModel>('users');

  runApp(const MaterialApp(
    home: HomeContact(),
    debugShowCheckedModeBanner: false,
  ));
}
