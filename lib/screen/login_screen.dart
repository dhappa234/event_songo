import 'package:flutter/material.dart';
import '../constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Widget _buildInputField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.7)),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kPrimaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo Placeholder
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                    child: Icon(Icons.event, size: 80, color: Colors.white)
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'EVENTSONGO!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'MANAGE EVENT IN REAL TIME',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),

              _buildInputField(
                hintText: 'Masukkan Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),

              _buildInputField(
                hintText: 'Masukkan Password',
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 30),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}