import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0) // ID da classe

class UserModel extends HiveObject {
  @HiveField(0) // indice do atributo
  late int user_id;
  @HiveField(1) // indice do atributo
  late String user_name;
  @HiveField(2) // indice do atributo
  late String email;
}
