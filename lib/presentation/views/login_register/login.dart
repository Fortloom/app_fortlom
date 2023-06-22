import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fortloom/core/framework/colors.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/presentation/views/initScreen.dart';
import 'package:fortloom/presentation/views/login_register/register.dart';
import 'package:fortloom/presentation/widgets/buttonLarge.dart';
import 'package:fortloom/presentation/widgets/textForm.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthService authService= new AuthService();
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

    final storage= new FlutterSecureStorage();
    Login(BuildContext context) async{

      var result= await authService.Login(_emailController.text.trim(), _passwordController.text.trim());
      print(result);
      await storage.write(key: "token", value: result);
      Navigator.push(
          context,
          PageTransition(
              child: InitScreen(),
              type: PageTransitionType.rightToLeft));

    }


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
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              child: const Text(
                '"' +
                    "Connect with the artists you love, or with the fans you adore" +
                    '"',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: _txtFormemail),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: _txtFormpasssword),
            ButtonLarge(
                text: 'Ingresar',
                onPressed: () {
                         Login(context);
                }),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Register(typeRegister: 'Fanatic'),
                        type: PageTransitionType.rightToLeft));
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: ScreenWH(context).width * 0.8,
                child: const Text('Register yourself as a fan',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Register(typeRegister: 'Artist'),
                        type: PageTransitionType.rightToLeft));
              },
              child: Container(
                alignment: Alignment.center,
                height: 40,
                width: ScreenWH(context).width * 0.8,
                child: const Text('Register yourself as an artist',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
