import 'package:fortloom/core/framework/colors.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/RegisterService.dart';
import 'package:fortloom/presentation/views/initScreen.dart';
import 'package:fortloom/presentation/views/login_register/login.dart';
import 'package:fortloom/presentation/widgets/buttonLarge.dart';
import 'package:fortloom/presentation/widgets/textForm.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Register extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _realnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _fanaticaliasController = TextEditingController();
  final RegisterService registerService = RegisterService();
  final String typeRegister;
  Register({required this.typeRegister});

  RegisteFanatic(BuildContext context) async {
    var result = await registerService.registerFanatic(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
        _realnameController.text.trim(),
        _lastnameController.text.trim(),
        _fanaticaliasController.text.trim());

    if (result == "new fanatic saved") {
      Navigator.push(context,
          PageTransition(child: Login(), type: PageTransitionType.rightToLeft));
    }
  }

  RegisterArtist(BuildContext context) async {
    var result = await registerService.registerArtist(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
        _realnameController.text.trim(),
        _lastnameController.text.trim());

    print('result: $result');

    if (result == "new artist saved") {
      Navigator.push(context,
          PageTransition(child: Login(), type: PageTransitionType.rightToLeft));
    }
  }

  @override
  Widget build(BuildContext context) {
    // String password = '';
    txtForm _txtFormemail = txtForm(
      title: 'Email',
      controller: _emailController,
      inputType: InputType.Email,
      txtColor: Colors.white,
    );
    txtForm _txtFormpasssword = txtForm(
      title: 'Password',
      controller: _passwordController,
      inputType: InputType.Password,
      txtColor: Colors.white,
    );
    txtForm _txtFormusername = txtForm(
      title: 'Username',
      controller: _usernameController,
      inputType: InputType.Default,
      txtColor: Colors.white,
    );
    txtForm _txtFormrealname = txtForm(
      title: 'Realname',
      controller: _realnameController,
      inputType: InputType.Default,
      txtColor: Colors.white,
    );
    txtForm _txtFormlastname = txtForm(
      title: 'Lastname',
      controller: _lastnameController,
      inputType: InputType.Default,
      txtColor: Colors.white,
    );
    txtForm _txtFormFanaticAlias = txtForm(
      title: 'FanaticAlias',
      controller: _fanaticaliasController,
      inputType: InputType.Default,
      txtColor: Colors.white,
    );

    return Scaffold(
      backgroundColor: background1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Image.asset('assets/imgs/logo.png',
                    height: ScreenWH(context).height * 0.3,
                    width: ScreenWH(context).width * 0.7)),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: _txtFormusername),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: _txtFormpasssword),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: _txtFormemail),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: _txtFormrealname),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: _txtFormlastname),
            if (typeRegister == "Fanatic")
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: _txtFormFanaticAlias),
            ButtonLarge(
                text: 'Register $typeRegister',
                onPressed: () {
                  if (typeRegister == "Fanatic") {
                    RegisteFanatic(context);
                  }
                  if (typeRegister == "Artist") {
                    RegisterArtist(context);
                  }
                })
          ],
        ),
      ),
    );
  }
}
