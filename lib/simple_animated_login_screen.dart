import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:simple_animated_login_screen/animation_enum.dart';

class SimpleAnimatedLoginScreen extends StatefulWidget {
  const SimpleAnimatedLoginScreen({super.key});

  @override
  State<SimpleAnimatedLoginScreen> createState() =>
      _SimpleAnimatedLoginScreenState();
}

class _SimpleAnimatedLoginScreenState extends State<SimpleAnimatedLoginScreen> {
  Artboard? riveArtBoard;
  late RiveAnimationController controllerLookIdle;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testPassword = '123456';
  String testEmail = 'MohamedOsama@gmail.com';
  final passwordFocusNode = FocusNode();
  bool isLookingRight = false;
  bool isLookingLeft = false;

  void removeAllController() {
    riveArtBoard!.artboard.removeController(controllerLookIdle);
    riveArtBoard!.artboard.removeController(controllerHandsDown);
    riveArtBoard!.artboard.removeController(controllerHandsUp);
    riveArtBoard!.artboard.removeController(controllerLookDownLeft);
    riveArtBoard!.artboard.removeController(controllerLookDownRight);
    riveArtBoard!.artboard.removeController(controllerSuccess);
    riveArtBoard!.artboard.removeController(controllerFail);
    isLookingRight = false;
    isLookingLeft = false;
  }

  void addIdleController() {
    removeAllController();
    riveArtBoard!.artboard.removeController(controllerLookIdle);
    debugPrint('idle');
  }

  void addHandsUpController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllerHandsUp);
    debugPrint('controllerHandsUp');
  }

  void addHandsDownController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllerHandsDown);
    debugPrint('controllerHandsDown');
  }

  void addLookLeftController() {
    removeAllController();
    isLookingLeft = true;
    riveArtBoard!.artboard.addController(controllerLookDownLeft);
    debugPrint('controllerLookLeft');
  }

  void addLookRightController() {
    removeAllController();
    isLookingRight = true;
    riveArtBoard!.artboard.addController(controllerLookDownRight);
    debugPrint('controllerLookRight');
  }

  void addSuccessController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllerSuccess);
    debugPrint('controllerSuccess');
  }

  void addFailController() {
    removeAllController();
    riveArtBoard!.artboard.addController(controllerFail);
    debugPrint('controllerFail');
  }

  void checkForPasswordFocusNodeToChangeAnimation() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(seconds: 1));
    if (formKey.currentState!.validate()) {
      addSuccessController();
    } else {
      addFailController();
    }
  }

  @override
  void initState() {
    super.initState();
    controllerLookIdle = SimpleAnimation(AnimationEnum.look_idle.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerLookDownRight =
        SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);

    rootBundle.load('assets/animated.riv').then((value) {
      final file = RiveFile.import(value);
      final artBoard = file.mainArtboard;
      artBoard.addController(controllerLookIdle);
      setState(() {
        riveArtBoard = artBoard;
      });
    });
    checkForPasswordFocusNodeToChangeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Login Screen',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20,
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width / 2.3,
                child: riveArtBoard == null
                    ? const SizedBox.shrink()
                    : Rive(
                        artboard: riveArtBoard!,
                      ),
              ),
              const SizedBox(height: 15),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      validator: (value) =>
                          value != testEmail ? 'Wrong Email' : null,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 10 &&
                            !isLookingLeft) {
                          addLookLeftController();
                        } else if (value.isNotEmpty &&
                            value.length > 10 &&
                            !isLookingRight) {
                          addLookRightController();
                        }
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 25),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      focusNode: passwordFocusNode,
                      validator: (value) =>
                          value != testPassword ? 'Wrong Password' : null,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            value.length < 10 &&
                            !isLookingLeft) {
                          addLookLeftController();
                        } else if (value.isNotEmpty &&
                            value.length > 10 &&
                            !isLookingRight) {
                          addLookRightController();
                        }
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 18),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 8,
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          passwordFocusNode.unfocus();
                          validateEmailAndPassword();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
