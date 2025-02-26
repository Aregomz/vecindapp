import 'package:flutter/material.dart';
import 'package:vecindapp/widgets/input.dart';
import 'package:vecindapp/widgets/button.dart';
import 'package:vecindapp/utils/constants.dart';

class Login extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlue, 
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 120),
              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: Column(
                  children: [
                    Input(
                      controller: usernameController,
                      hintText: "Usuario",
                      icon: Icons.person,
                    ),
                    SizedBox(height: 15),
                    Input(
                      controller: passwordController,
                      hintText: "Contraseña",
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: 20),

                    Button(
                      text: "Iniciar Sesión",
                      onPressed: () {
                        print("Usuario: ${usernameController.text}");
                      },
                    ),

                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {},
                      child: Text("¿Olvidaste tu contraseña?", style: TextStyle(color: Colors.blueAccent)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
