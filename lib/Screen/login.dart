import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/auth_provider.dart';
import '../Widget/button.dart';
import '../Widget/snackbar.dart';
import '../Widget/text_field.dart';
import 'home_screen.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isEmailValid = false;
  bool hasEmailInput = false;
  String passwordStrength = "";
  bool hasPasswordInput = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String result = await authProvider.loginUser(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (result == "success") {
      showSnackBar(context, "Login Success!", SnackBarType.success);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      showSnackBar(context, result, SnackBarType.error);
    }
  }

  void validateEmail(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    setState(() {
      hasEmailInput = email.isNotEmpty;
      isEmailValid = emailRegex.hasMatch(email);
    });
  }

  void validatePassword(String password) {
    setState(() {
      hasPasswordInput = password.isNotEmpty;
      if (password.length < 6) {
        passwordStrength = "Weak";
      } else if (password.length < 12) {
        passwordStrength = "Medium";
      } else {
        passwordStrength = "Strong";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF5F9FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "e-Shop",
                      style: TextStyle(
                        color: Color(0xFF0c54be),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              TextFieldInput(
                textEditingController: emailController,
                hintText: 'Email',
                textInputType: TextInputType.text,
                onChanged: (value) {
                  validateEmail(value);
                },
                suffixIcon: hasEmailInput
                    ? isEmailValid
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.dangerous, color: Colors.red)
                    : null,
              ),
              TextFieldInput(
                textEditingController: passwordController,
                hintText: 'Password',
                textInputType: TextInputType.text,
                isPass: true,
                onChanged: (value) {
                  validatePassword(value);
                },
                suffixIcon: hasPasswordInput
                    ? passwordStrength == "Strong"
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : passwordStrength == "Medium"
                            ? const Icon(Icons.check_circle, color: Colors.orangeAccent)
                            : const Icon(Icons.dangerous, color: Colors.red)
                    : null,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButtons(onTap: loginUser, text: "Log In"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "New here?",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      " Sign Up",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0c54be)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
