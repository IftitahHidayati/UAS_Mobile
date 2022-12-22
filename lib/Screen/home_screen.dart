import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_login/Screen/auth/login_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'Add/button.dart';
import 'Add/logoutbutton.dart';
import 'edit_category.dart';
import '../components/category.dart';
import '../Services/category_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List listCategory = [];
  String name = '';
  final TextEditingController addCategoryTxt = TextEditingController();

  getCategory() async {
    final response = await AuthServices().getCategories();
    print('respone from kategori');
    print(response);
    var dataResponse = json.decode(response.body);
    setState(
      () {
        var listRespon = dataResponse['data'];
        print(listRespon);
        for (var i = 0; i < listRespon.length!; i++) {
          listCategory.add(
            Category.fromJson(listRespon[i]),
          );
        }
      },
    );
  }

  addCategory() async {
    final name = addCategoryTxt.text;
    final response = await CategoryService().addCategory(name);
    print(response.body);
    // Navigator.pushNamed(context, "/");
    listCategory.clear();
    getCategory();
    addCategoryTxt.clear();
  }

  getUser() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(
      () {
        const key = 'name';
        final value = sharedPref.get(key);
        name = '$value';
      },
    );
  }

  sweatAlert() async {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Alert!",
      desc: "Ingin Melanjutkan Logout?",
      buttons: [
        DialogButton(
          child: Text(
            "Iya",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () {
            logoutPressed();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Logout success',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ],
    ).show();
    return;
  }

  @override
  void initState() {
    getUser();
    super.initState();
    getCategory();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 75, 101, 234),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Color.fromARGB(196, 0, 0, 0),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            onPressed: () {
              sweatAlert();
            },
          )
        ],
      ),
      body: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 108, 131, 231),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: const SizedBox(
                  height: 4,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'List Categories',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      child: TextFormField(
                        controller: addCategoryTxt,
                        decoration: InputDecoration(
                          hintText: "Input Your Categories Name",
                          labelText: "Add Categories",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          suffixIcon: Container(
                            margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                            child: ElevatedButton(
                              child: const Text("Add"),
                              onPressed: () {
                                addCategory();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                        ),
                        child: ListView.builder(
                            itemCount: listCategory.length,
                            itemBuilder: (context, index) {
                              var kategori = listCategory[index];
                              return Dismissible(
                                key: UniqueKey(),
                                background: Container(
                                  color: Color.fromARGB(255, 51, 179, 55),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.create_rounded,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.redAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onDismissed:
                                    (DismissDirection direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => edit(
                                              category: listCategory[index]),
                                        ));
                                  } else {
                                    final response = await CategoryService()
                                        .deleteCategory(listCategory[index]);
                                    print(response.body);
                                  }
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 9,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18),
                                      child: Text(
                                        kategori.name,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void logoutPressed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    const key = 'token';
    final value = preferences.get(key);
    setState(
      () {
        preferences.remove('token');
        preferences.clear();
      },
    );

    final token = '$value';
    // print(token);
    http.Response response = await AuthServices.logout(token);
    print(response.body);
    // final response = await AuthServices().logout(token);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}
