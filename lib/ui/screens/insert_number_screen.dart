import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';
import 'package:tuie_driver_taxi/constants/constant_url.dart';
import 'package:tuie_driver_taxi/provider/provider_autenticacao.dart';
import 'package:tuie_driver_taxi/provider/provider_usuario.dart';
import 'package:tuie_driver_taxi/ui/screens/code_verification_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/register_login_screen.dart';


class InsertNumberScreen extends StatefulWidget {
  InsertNumberScreen({Key? key}) : super(key: key);


  @override
  State<InsertNumberScreen> createState() => _InsertNumberScreenState();
}

class _InsertNumberScreenState extends State<InsertNumberScreen> {

  String countryDial = "+244";
  String telefone = "";
  bool numero_telefone = false;

  bool processando = false;

  TextEditingController _telefone_usuario_controller = TextEditingController();

  final FlutterNetworkConnectivity _flutterNetworkConnectivity =
  FlutterNetworkConnectivity(
    isContinousLookUp: true,
    lookUpDuration: const Duration(seconds: 5),
  );

  bool? _isInternetAvailableOnCall;
  bool _isInternetAvailableStreamStatus = false;

  StreamSubscription<bool>? _networkConnectionStream;

  //********************** INITSTATE ********************** */
  @override
  void initState() {
    super.initState();
    _flutterNetworkConnectivity.getInternetAvailabilityStream().listen((event) {
      _isInternetAvailableStreamStatus = event;
      setState(() {});
    });
    init();  processando = false;
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

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final motorista = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstantColor.whiteColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ConstantColor.whiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              //---------------------------- SPACE ---------------------------- -/
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),

              Text(
                'Insere o teu número.',
                style: GoogleFonts.quicksand(
                    color: ConstantColor.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),

        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              //----------------- SPACE ------------------- -/
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                height: MediaQuery.of(context).size.height / 12,
                width: MediaQuery.of(context).size.width / 1.2,
                decoration: BoxDecoration(
                    color: ConstantColor.whiteColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 1, color: ConstantColor.colorPrimary, style: BorderStyle.solid)
                ),
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.04),
                child: Center(
                  child: Row(
                    children: [

                      CountryListPick(
                      // if you need custom picker use this
                       pickerBuilder: (context, CountryCode ?countryCode) {
                         countryDial = countryCode!.dialCode!;
                        return Row(
                          children: [
                             Image.asset(
                               countryCode.flagUri!,
                               package: 'country_list_pick',
                               width: 30,
                               height: 30,
                             ),
                             Text(
                               ' '+countryCode.dialCode!,
                               style: GoogleFonts.quicksand(
                                   fontSize: 20,
                                   fontWeight: FontWeight.normal,
                                   color: ConstantColor.blackColor
                               ),
                             ),
                           ],
                         );
                       },
                      theme: CountryTheme(
                        isShowFlag: true,
                        isShowTitle: true,
                        isShowCode: true,
                        isDownIcon: true,
                        showEnglishName: false,
                        labelColor: Colors.blueAccent,
                      ),
                      initialSelection: '+244',
                      onChanged: (CountryCode? code) {
                        countryDial = code.toString();
                      },
                      ),


                      Expanded(
                        child: Center(
                          child: TextFormField(
                            maxLines: null,
                            textInputAction: TextInputAction.next,
                            style: GoogleFonts.quicksand(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: ConstantColor.blackColor),
                            decoration: InputDecoration.collapsed(
                              border: InputBorder.none,
                              hintText: 'Digite o número',
                              hintStyle: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: ConstantColor.blackColor,
                              ),
                            ),
                            onChanged: (value){
                                value.length == 9 ? numero_telefone = true : numero_telefone = false;
                                telefone = _telefone_usuario_controller.text;
                                motorista.checkMotorista(countryDial+telefone);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty || value.length > 9) {
                                return 'Por favor digite o telefone correto';
                              } else if (value.length == 9){
                                  numero_telefone = true;
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: _telefone_usuario_controller,
                            // obscureText: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //----------------- SPACE ------------------- -/
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Text(
                  'Vamos enviar-te um código SMS para confirmar o seu número caso não esteja cadastrado.',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: ConstantColor.colorClickButton,
                  ),
                ),
              ),

              _isInternetAvailableStreamStatus
                  ? Text(
                '',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: ConstantColor.blackColor,
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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

              //---------------------------- SPACE ---------------------------- -/
              isKeyboard ? SizedBox(height: MediaQuery.of(context).size.height * 0.04) : SizedBox(height: MediaQuery.of(context).size.height * 0.50),

              numero_telefone && motorista.motoristaTelefone != null ?
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
                            return ConstantColor.colorPrimary.withOpacity(0.04);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return ConstantColor.whiteColor;
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => CodeVerificationScreen(
                              numero_telefone: countryDial+_telefone_usuario_controller.text,
                              isLogin: true,
                                emailMotorista: motorista.motoristaEmail!
                            )
                          //
                          //ProductPage
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Login',
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ConstantColor.whiteColor),
                      ),
                    ),
                  ),
                ),
              ) :
              numero_telefone && motorista.motoristaTelefone == null ? Center(
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
                            return ConstantColor.colorPrimary.withOpacity(0.04);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return ConstantColor.whiteColor;
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => CodeVerificationScreen(
                              numero_telefone: countryDial+_telefone_usuario_controller.text,
                              isLogin: false,
                              emailMotorista: ''
                            )
                          //
                          //ProductPage
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        'Confirmar',
                        style: GoogleFonts.quicksand(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ConstantColor.whiteColor),
                      ),
                    ),
                  ),
                ),
              ):
              processando ? Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: ConstantColor.whiteColor,
                  size: 30,
                ),
              ) :
              Container(),


                 // && !_isInternetAvailableStreamStatus

            ],
          ),
        ),
      ),
    );
  }


}
