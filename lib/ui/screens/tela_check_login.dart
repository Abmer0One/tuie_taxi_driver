import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuie_driver_taxi/provider/provider_autenticacao.dart';
import 'package:tuie_driver_taxi/ui/screens/home_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/register_login_screen.dart';



class TelaCheckLogin extends StatefulWidget {
  const TelaCheckLogin({Key? key}) : super(key: key);

  @override
  State<TelaCheckLogin> createState() => _TelaCheckLoginState();
}

class _TelaCheckLoginState extends State<TelaCheckLogin>{

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.user != null) {
          return HomeScreen();
        } else {
          return const RegisterLoginScreen();
        }
      },
    );
  }
}
