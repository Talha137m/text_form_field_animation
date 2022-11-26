import 'package:flutter/material.dart';

class EmailInputField extends StatefulWidget {
  final bool fadeEmailValue;
  final TextEditingController emailController;
  const EmailInputField(
      {super.key, required this.fadeEmailValue, required this.emailController});

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField>
    with SingleTickerProviderStateMixin {
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
  //make the object of focus node
  FocusNode node = FocusNode();
  //make the data member of textEditingController
  late TextEditingController emailController;
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
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
        ColorTween(begin: Colors.grey.withOpacity(0), end: Colors.blue);
    //make the animation of the color
    animation = tween.animate(animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: widget.fadeEmailValue ? 0 : 1),
          duration: const Duration(microseconds: 300),
          builder: ((context, value, child) => Opacity(
                opacity: value,
                child: child,
              )),
          child: Form(
            child: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              focusNode: node,
              decoration: const InputDecoration(
                hintText: 'E_mail',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  if (isValidation(value)) {
                    setState(() {
                      bottomAnimationValue = 0;
                      opacityAnimationValue = 1;
                      paddingAnimation = const EdgeInsets.only(top: 0);
                    });
                    animationController.forward();
                  } else {
                    animationController.reverse();
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
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(microseconds: 500),
              width: widget.fadeEmailValue ? 0 : 300,
              child: TweenAnimationBuilder<double>(
                curve: Curves.easeIn,
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
          child: AnimatedPadding(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 500),
            padding: paddingAnimation,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: widget.fadeEmailValue ? 0 : 1),
              duration: const Duration(milliseconds: 700),
              builder: ((context, value, child) => Opacity(
                    opacity: value,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0)
                            .copyWith(bottom: 0),
                        child: Icon(Icons.check_rounded,
                            size: 27,
                            color: animation.value // _animation.value,
                            ),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

bool isValidation(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}
