import 'dart:math';

import 'package:flutter/material.dart';

extension PasswordValidation on String {
  bool isValidate() {
    return contains(r'[0–9]');
  }
}

bool isValidation(String password) {
  return (RegExp(r'[0–9]').hasMatch(password));
}

class PasswordInputField extends StatefulWidget {
  final bool fadePasswordEndValue;
  final TextEditingController passwordEditingController;
  final GlobalKey<FormFieldState> globalKey;
  const PasswordInputField(
      {super.key,
      required this.fadePasswordEndValue,
      required this.passwordEditingController,
      required this.globalKey});

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField>
    with SingleTickerProviderStateMixin {
  late GlobalKey<FormFieldState> globalKey;
  double width = 0;
  //padding
  EdgeInsets paddingAnimation = const EdgeInsets.only(top: 20);
  //make the animation controller data member
  late AnimationController animationController;
  //make the data member of color template type
  late Animation<Color?> animation;
  //initialize the value of show the line in the textfield
  double bottomAnimationValue = 0;
  //initialize the opacity value
  double opacityAnimationValue = 0;
  //show text or not into password field
  bool obscure = false;
  //make the object of focus node
  FocusNode node = FocusNode();
  //make the data member of textEditingController
  late TextEditingController passwordEditingController;
  @override
  void initState() {
    globalKey = widget.globalKey;
    passwordEditingController = widget.passwordEditingController;
    node.addListener(() {
      if (node.hasFocus) {
        setState(() {
          bottomAnimationValue = 1;
        });
      } else {
        setState(() {
          bottomAnimationValue = 0;
        });
      }
    });
    //initialize the animationController sync with rendreing frame
    animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 300));
    //make the tween
    final tween =
        ColorTween(begin: Colors.blue.withOpacity(0), end: Colors.blue);
    //make the animation of the color
    animation = tween.animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: widget.fadePasswordEndValue ? 0 : 1),
          duration: const Duration(microseconds: 300),
          builder: ((context, value, child) => Opacity(
                opacity: value,
                child: child,
              )),
          child: TextFormField(
            key: globalKey,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Field should not empty';
              }
              return null;
            },
            obscureText: obscure,
            controller: passwordEditingController,
            keyboardType: TextInputType.text,
            focusNode: node,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (isValidation(value)) {
                  setState(() {
                    bottomAnimationValue = 0;
                    opacityAnimationValue = 1;
                    paddingAnimation = const EdgeInsets.only(top: 0);
                  });
                  animationController.forward(from: 0);
                } else {
                  animationController.reverse(from: 1);
                  setState(() {
                    bottomAnimationValue = 1;
                    opacityAnimationValue = 0;
                    paddingAnimation = const EdgeInsets.only(top: 22);
                  });
                }
              } else {
                setState(() {
                  bottomAnimationValue = 0;
                });
              }
            },
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(seconds: 3),
              width: widget.fadePasswordEndValue ? 0 : 300,
              child: TweenAnimationBuilder<double>(
                curve: Curves.linear,
                tween: Tween(begin: 0, end: bottomAnimationValue),
                duration: const Duration(seconds: 2),
                builder: ((context, value, child) => LinearProgressIndicator(
                      value: value,
                      color: Colors.black,
                      backgroundColor: Colors.grey.withOpacity(0.5),
                    )),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: TweenAnimationBuilder<double>(
            tween: Tween(
                begin: 0,
                end: opacityAnimationValue == 0
                    ? 0
                    : widget.fadePasswordEndValue
                        ? 0
                        : 1),
            duration: const Duration(milliseconds: 700),
            builder: ((context, value, child) => Opacity(
                  opacity: value,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0)
                          .copyWith(bottom: 0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                        child: Icon(
                          obscure ? Icons.visibility : Icons.visibility_off,
                          size: 27,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}

/*Positioned.fill(
          child: AnimatedPadding(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 500),
            padding: paddingAnimationValue,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: widget.fadeEmail ? 0 : 1),
              duration: Duration(milliseconds: 700),
              builder: ((context, value, child) => Opacity(
                    opacity: value,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0)
                            .copyWith(bottom: 0),
                        child: Icon(Icons.check_rounded,
                            size: 27,
                            color: _animation.value // _animation.value,
                            ),
                      ),
                    ),
                  )),
            ),
          ),
        ),*/
