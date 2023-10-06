import 'package:booking_transition_admin/feature/controller/login_controller.dart';
import 'package:booking_transition_admin/untils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  static late bool isLogin;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: AppColor.mainColor,
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          height: 300,
          width: 400,
          child: Column(
            children: [
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: 'VeMienTay',
                      style: TextStyle(
                          fontFamily: 'Roboto bold',
                          color: AppColor.mainColor,
                          fontSize: 25)),
                  const TextSpan(
                      text: 'Admin',
                      style: TextStyle(
                          fontFamily: 'Roboto bold',
                          color: Colors.grey,
                          fontSize: 25)),
                ]),
              ),
              Divider(
                height: 1,
                color: AppColor.mainColor,
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                  child: Center(
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        hintStyle: TextStyle(color: AppColor.mainColor),
                        //icon: const Icon(Icons.account_circle_outlined),
                        label: Text(
                          'Username',
                          style: TextStyle(color: AppColor.mainColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          // Change the default border color
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: AppColor.mainColor,
                              width: 2), // Change color and width
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: AppColor.mainColor),
                        //icon: const Icon(Icons.account_circle_outlined),
                        label: Text(
                          'Password',
                          style: TextStyle(color: AppColor.mainColor),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          // Change the default border color
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: AppColor.mainColor,
                              width: 2), // Change color and width
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.mainColor,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            final _loginController = LoginController();
                            await _loginController.onLogin(
                                _usernameController.text,
                                _passwordController.text);
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontFamily: 'Roboto bold', fontSize: 20),
                          )),
                    )
                  ],
                ),
              ))
            ],
          ),
        )),
      ),
    ));
  }
}
