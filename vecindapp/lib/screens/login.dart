import 'package:flutter/material.dart';
import 'package:vecindapp/widgets/input.dart';
import 'package:vecindapp/widgets/button.dart';
import 'package:vecindapp/screens/home_screen.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool showForm = false;
  bool isLogin = true;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void toggleForm(bool login) {
    setState(() {
      isLogin = login;
      showForm = true;
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo azul rey
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF003C8F),
            ),
          ),

          // Figuras decorativas
          Positioned(
            top: -40,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFF0050B3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF0047A0),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 150,
            left: -50,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFF004099),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Image.asset(
                    'assets/logoVA1.png',
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bienvenido a tu hogar...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),

                  if (!showForm) ...[
                    // Botón Iniciar Sesión
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => toggleForm(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            color: Color(0xFF003C8F),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Botón Registrarse
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => toggleForm(false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Registrarse",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ] else ...[
                    SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                        ),
                        child: Column(
                          children: [
                            Input(
                              controller: usernameController,
                              hintText: isLogin ? "Correo" : "Nombre",
                              icon: Icons.person,
                            ),
                            SizedBox(height: 15),
                            Input(
                              controller: passwordController,
                              hintText: "Contraseña",
                              icon: Icons.lock,
                              obscureText: true,
                            ),
                            if (!isLogin) ...[
                              SizedBox(height: 15),
                              Input(
                                controller: confirmPasswordController,
                                hintText: "Confirmar Contraseña",
                                icon: Icons.lock_outline,
                                obscureText: true,
                              ),
                            ],
                            SizedBox(height: 20),
                            Button(
                              text: isLogin ? "Iniciar Sesión" : "Registrarse",
                              onPressed: () {
                                final email = usernameController.text.trim();
                                final password = passwordController.text.trim();
                                final confirmPassword = confirmPasswordController.text.trim();

                                if (!isLogin && password != confirmPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Las contraseñas no coinciden"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // Navegar a HomeScreen
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => HomeScreen()),
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            if (isLogin)
                              TextButton(
                                onPressed: () {},
                                child: Text("¿Olvidaste tu contraseña?",
                                    style: TextStyle(color: Colors.blueAccent)),
                              ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showForm = false;
                                  _controller.reset();
                                  confirmPasswordController.clear();
                                });
                              },
                              child: Text("Volver", style: TextStyle(color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
