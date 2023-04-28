import 'package:contact_crud_hive/common/box_user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'contact_listview.dart';
import 'form_contact_fielder.dart';
import 'model/user.dart';

class HomeContact extends StatefulWidget {
  const HomeContact({super.key});

  @override
  State<HomeContact> createState() => _HomeContactState();
}

class _HomeContactState extends State<HomeContact> {
  final _formKey = GlobalKey<FormState>();

  final idUserControl = TextEditingController();
  final nameUserControl = TextEditingController();
  final emailUserControl = TextEditingController();

  @override
  void dispose() {
    idUserControl.dispose();
    nameUserControl.dispose();
    emailUserControl.dispose();
    Hive.close(); // fechar as boxes
    super.dispose();
  }

  /* tirar depois */
  List<UserModel> testeData() {
    List<UserModel> users = [];
    UserModel user = UserModel()
      ..user_id = 1
      ..user_name = 'Joao'
      ..email = 'xx@xx.com';
    users.add(user);
    users.add(user);
    users.add(user);
    users.add(user);

    return users;
  }
  int geraNovoId(Iterable<UserModel> users) {
    return (users.isNotEmpty ?users.last.user_id + 1 : 0);
  }
  Future<void> addUser(String name, String email, int? id) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // pega a caixa aberta
      final box = UserBox.getUsers();
      id = id ?? geraNovoId(box.values);
      if (box.get(id) == null) {
        final user = UserModel()
          ..user_id = id
          ..user_name = name
          ..email = email;
        box.add(user);
      } else {
        var user = box.get(id);
        user?.email = email;
        user?.user_name = name;
        user?.save();
      }
      _clearTextControllers();
    }
  }

  Future<void> editUser(UserModel user) async {
    idUserControl.text = user.user_id.toString();
    nameUserControl.text = user.user_name;
    emailUserControl.text = user.email;
  }

  void _clearTextControllers() {
    idUserControl.clear();
    nameUserControl.clear();
    emailUserControl.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Contatos'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              FormContactFielder(
                enable: false,
                controller: idUserControl,
                iconData: Icons.person,
                hintTextName: 'Código',
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: nameUserControl,
                iconData: Icons.person_outline,
                hintTextName: 'Nome',
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: emailUserControl,
                iconData: Icons.email_outlined,
                textInputType: TextInputType.emailAddress,
                hintTextName: 'Email',
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => addUser(
                          nameUserControl.text,
                          emailUserControl.text,
                          idUserControl.text.isEmpty ? null : int.parse(idUserControl.text),
                        ),
                        child: const Text('Adicionar'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _clearTextControllers,
                        child: const Text('Limpar Campos'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: UserBox.getUsers().listenable(),
                builder: (BuildContext context, Box userBox, Widget? child) {
                  final users = userBox.values.toList().cast<UserModel>();
                  if (users.isEmpty) {
                    return Center(
                      child: const Text(
                        'No Users Found',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return ContactListView(
                      users: users,
                      onEditContact: editUser,
                    );
                  }
                },
              ),
              //ContactListView(users: users)
            ],
          ),
        ),
      ),
    );
  }
}
