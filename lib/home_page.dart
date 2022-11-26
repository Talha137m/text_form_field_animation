import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tween_animation_text_field/email_input_field.dart';
import 'package:tween_animation_text_field/password_input_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GlobalKey<FormFieldState> globalKey;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  double elementOpacity = 1;
  double loadingBallSize = 1;
  bool loadingBallApear = false;
  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    var minimum = min(width, height);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          bottom: false,
          child: loadingBallApear
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 30.0),
                  child: Container())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, height * 0.1, 0, 0),
                          child: SizedBox(
                            width: width * 0.2,
                            height: height * 0.2,
                            child: Image.asset(
                              'assets/images/robo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 1, end: elementOpacity),
                          duration: const Duration(microseconds: 300),
                          builder: ((context, value, child) => Opacity(
                                opacity: value,
                                child: child,
                              )),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0, height * 0.08, width * 0.4, 0),
                                child: Text(
                                  'Welcome ,',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: minimum * 0.06,
                                      fontWeight: FontWeight.w600,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0, height * 0.02, width * 0.3, 0),
                                child: Text(
                                  'Sign in to continue',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: minimum * 0.05,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: minimum * 0.1),
                                child: SizedBox(
                                  width: width * 0.7,
                                  child: EmailInputField(
                                    emailController: emailController,
                                    fadeEmailValue: elementOpacity == 0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
                                child: SizedBox(
                                  width: width * 0.7,
                                  child: PasswordInputField(
                                    fadePasswordEndValue: elementOpacity == 0,
                                    passwordEditingController:
                                        passwordController,
                                    globalKey: globalKey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.08),
                                child: Container(
                                  width: width * 0.35,
                                  height: height * 0.07,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade600,
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (globalKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Processing')));
                                      }
                                    },
                                    child: Text(
                                      'Get Started →',
                                      style: TextStyle(
                                          fontSize: minimum * 0.04,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}

/* Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, minimum * 0.1, 0, 0),
              child: SizedBox(
                width: width * 0.2,
                height: height * 0.2,
                child: Image.asset(
                  'assets/images/robo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, minimum * 0.08, 0, 0),
              child: Text(
                'Welcome ,',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: minimum * 0.06,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(minimum * 0.12, minimum * 0.02, 0, 0),
              child: Text(
                'Sign in to continue',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: minimum * 0.05,
                    fontWeight: FontWeight.w400,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: minimum * 0.07),
                child: SizedBox(
                  width: width * 0.7,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Emial',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.7,
              child: TextFormField(
                obscureText: _passwordVisibility,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisibility
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisibility = !_passwordVisibility;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: minimum * 0.08),
              child: Container(
                width: width * 0.15,
                height: height * 0.08,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Get Started →',
                    style: TextStyle(
                        fontSize: minimum * 0.03, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),*/