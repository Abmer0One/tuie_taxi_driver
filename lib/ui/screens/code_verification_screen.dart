
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';
import 'package:tuie_driver_taxi/provider/alerta_provider.dart';
import 'package:tuie_driver_taxi/provider/provider_autenticacao.dart';
import 'package:tuie_driver_taxi/ui/screens/home_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/insert_number_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/register_login_screen.dart';

class CodeVerificationScreen extends StatefulWidget {
  CodeVerificationScreen({Key? key,
    required this.numero_telefone,
    required this.isLogin,
    required this.emailMotorista
  }) : super(key: key);
  String numero_telefone;
  bool isLogin;
  String emailMotorista;

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {

  //****************************************************
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _checkPasswordController = TextEditingController();



  bool? _isInternetAvailableOnCall;
  bool _isInternetAvailableStreamStatus = false;

  StreamSubscription<bool>? _networkConnectionStream;

  final FlutterNetworkConnectivity _flutterNetworkConnectivity =
  FlutterNetworkConnectivity(
    isContinousLookUp: true,
    // optional, false if you cont want continous lookup.
    lookUpDuration: const Duration(seconds: 5),
    // optional, to override default lookup duration.
    // lookUpUrl: 'example.com', // optional, to override default lookup url
  );

  @override
  void initState() {
    _flutterNetworkConnectivity.getInternetAvailabilityStream().listen((event) {
      _isInternetAvailableStreamStatus = event;
      setState(() {});
    });
    init();
    super.initState();
  }

  @override
  void dispose() {
    _networkConnectionStream?.cancel();
    _flutterNetworkConnectivity.unregisterAvailabilityListener();
    super.dispose();
  }

  void init() async {
    await _flutterNetworkConnectivity.registerAvailabilityListener();
  }

  _submitForm(AlertDialogProvider alertDialogProvider) {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (widget.isLogin) {
        // Login
        Provider.of<AuthProvider>(context, listen: false).signIn(widget.emailMotorista, password, alertDialogProvider, context);
        //progress = true;
        alertDialogProvider.sucessLoginAlert(context, 'Sucesso', 'Login efectuado com sucesso.');
      } else {
        // Registro
        Provider.of<AuthProvider>(context, listen: false).signUp('nome', 'sobrenome', widget.numero_telefone,
          password, 'estado', email, 'BI', 'passaport');
        //print('registou');
        alertDialogProvider.sucessRegisterAlert(context, 'Sucesso', 'Registo efectuado com sucesso!.');
      }
      // Autenticação bem-sucedida, faça o que for necessário aqui
    } catch (e) {
      alertDialogProvider.errorAlert(context, 'Alerta', 'Erro ao inserir os dados.');
     // print('erro1'+e.toString());
      if (e is FirebaseAuthException) {
        if (e.code == 'wrong-password') {
          //print(e.toString());
          alertDialogProvider.errorAlert(context, 'Alerta', 'Credenciais errada! retifique.');
        } else if (e.code == 'user-not-found') {
          alertDialogProvider.errorAlert(context, 'Alerta', 'Usuario não esta registado.');
        } else {
          alertDialogProvider.errorAlert(context, 'Alerta', 'Erro ao inserir os dados.');
          //print('erro2'+e.toString());
        }
      } else {
        alertDialogProvider.errorAlert(context, 'Alerta', 'Erro ao inserir os dados.');
        //print('erro3'+e.toString());
      }
    }
  }

  //**************** WIDGET ROOT ************* */
  @override
  Widget build(BuildContext context) {
    final alertDialogProvider = Provider.of<AlertDialogProvider>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [

              //--------------- APPBAR --------------- -/
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  //::::::::::::::: ARROW BACK ::::::::::: :/
                  InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>  InsertNumberScreen(),
                          //ProductPage
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.08, top: MediaQuery.of(context).size.height * 0.04),
                      height: MediaQuery.of(context).size.height / 16,
                      width: MediaQuery.of(context).size.width / 9,
                      decoration: BoxDecoration(
                        color: ConstantColor.transparentColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  //----------------- SPACE ------------------- -/
                  const SizedBox(width: 30,),

                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Text(
                      widget.isLogin ? 'Insere a senha' : 'Insere o Email e senha',
                      style: GoogleFonts.quicksand(
                          color: ConstantColor.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                  ),
                ],
              ),

              //----------------- SPACE ------------------- -/
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              //--------- DESRIPTION INPUT ---------- -/
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preencha os campos...',
                      style: GoogleFonts.quicksand(
                          color: ConstantColor.colorClickButton,
                          fontSize: 15,
                          fontWeight: FontWeight.normal
                      ),
                    ),

                  ],
                ),
              ),

              //----------------- SPACE ------------------- -/
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              //----------- INPUTS CODE ------------- -/
              widget.isLogin ? Container() :
              Container(
                height: MediaQuery.of(context).size.height / 12,
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    color: ConstantColor.colorLigth.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: ConstantColor.colorPrimary, style: BorderStyle.solid)
                ),
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                child: Center(
                  child: TextFormField(
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: 'Email',
                      hintStyle: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: ConstantColor.blackColor),
                    ),
                    //focusNode: telefone_passageiro,
                    validator: (value) {
                      setState(() {
                        //telefone_usuario = value;
                      });
                      if (value == null || value.isEmpty) {
                        return 'Por favor digite o telefone correto';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    // obscureText: true,
                  ),
                ),
              ),

              //----------------- SPACE ------------------- -/
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              Container(
                height: MediaQuery.of(context).size.height / 12,
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    color: ConstantColor.colorLigth.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: ConstantColor.colorPrimary, style: BorderStyle.solid)
                ),
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                child: Center(
                  child: TextFormField(

                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: 'Senha',
                      hintStyle: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: ConstantColor.blackColor),
                    ),
                    //focusNode: telefone_passageiro,
                    validator: (value) {
                      setState(() {
                        //telefone_usuario = value;
                      });
                      if (value == null || value.isEmpty) {
                        return 'Por favor digite o telefone correto';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                ),
              ),

              //----------------- SPACE ------------------- -/
              const SizedBox(height: 10,),

              _isInternetAvailableStreamStatus
                  ?
              Text('',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: ConstantColor.blackColor,
                ),
              )
                  : Column(
                children: [
                  Icon(
                    Icons.warning,
                    size: 50,
                    color: ConstantColor.colorPrimary,
                  ),
                  Text(
                    'Estas Offline, Conecte-se a internet.',
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: ConstantColor.blackColor,
                    ),
                  ),
                ],
              ),

              //----------- BUTTON CHECK & RESEND ----------- -/
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                    color: ConstantColor.colorPrimary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return ConstantColor.colorPrimary.withOpacity(0.5);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return ConstantColor.whiteColor;
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () async{
                        await _submitForm(alertDialogProvider);
                    },
                    child: Center(
                      child: Text(
                        'Confirmar',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.whiteColor
                        ),
                      ),
                    ),
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
