import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';
import 'package:tuie_driver_taxi/provider/provider_autenticacao.dart';
import 'package:tuie_driver_taxi/ui/screens/register_login_screen.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key,
    required this.id_usuario,
    required this.nome_usuario,
    required this.sobrenome_usuario,
    required this.telefone_usuario,
    required this.password_usuario,
    required this.email_usuario,
    required this.bi_usuario,
    required this.passaport_usuario,
    required this.foto_usuario,

  }) : super(key: key);
  String id_usuario;
  String nome_usuario;
  String sobrenome_usuario;
  String telefone_usuario;
  String password_usuario;
  String email_usuario;
  String bi_usuario;
  String passaport_usuario;
  String foto_usuario;


  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {


  TextEditingController? nome_usuario;
  TextEditingController? sobrenome_usuario;
  TextEditingController? telefone_usuario;
  TextEditingController? password_usuario;
  TextEditingController? email_usuario;
  TextEditingController? bi_usuario;
  TextEditingController? passaport_usuario;
  TextEditingController? foto_usuario;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  File? _pickedImage_usuario;

  @override
  void initState() {
    nome_usuario = TextEditingController();
    sobrenome_usuario = TextEditingController();
    telefone_usuario = TextEditingController();
    password_usuario = TextEditingController();
    email_usuario = TextEditingController();
    bi_usuario = TextEditingController();
    passaport_usuario = TextEditingController();
    foto_usuario = TextEditingController();
    super.initState();
  }

  void _pickImage_usuario() async {
    final pickedImageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage_usuario = File(pickedImageFile.path);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: ConstantColor.blackColor,
        backgroundColor: ConstantColor.whiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Perfil',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),

            InkWell(
              onTap: (){
                setState(() {
                  showDialog(context: context, builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height / 1.2,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Form(
                            key: _form,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                //----------------- SPACE ------------------- -/


                                //------------------- INPUT PHOTO -------------------- -/
                                Column(
                                  children: [

                                    Text(
                                      "Editar Perfil",
                                      style: GoogleFonts.cormorantGaramond(
                                          fontSize: 20,
                                          color: ConstantColor.blackColor,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),

                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage: _pickedImage_usuario != null ? FileImage(_pickedImage_usuario!) : null,
                                    ),

                                    TextButton(
                                      onPressed: _pickImage_usuario,
                                      child: Text(
                                        'Selecionar foto',
                                        style: GoogleFonts.cormorantGaramond(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context).size.height * 0.02,
                                          color: ConstantColor.blackColor,
                                        ),),
                                    ),


                                  ],
                                ),

                                //----------- INPUT NAME ---------------- -/
                                TextFormField(
                                  controller: nome_usuario,
                                  decoration: InputDecoration(labelText: 'Nome'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o Nome';
                                    }
                                    return null;
                                  },
                                ),


                                TextFormField(
                                  controller: sobrenome_usuario,
                                  decoration: InputDecoration(labelText: 'Sobrenome'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o Sobrenome';
                                    }
                                    return null;
                                  },
                                ),

                                TextFormField(
                                  controller: telefone_usuario,
                                  decoration: InputDecoration(labelText: 'Telefone'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o Telefone';
                                    }
                                    return null;
                                  },
                                ),

                                TextFormField(
                                  controller: email_usuario,
                                  decoration: InputDecoration(labelText: 'Email'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o Email';
                                    }
                                    return null;
                                  },
                                ),

                                TextFormField(
                                  controller: bi_usuario,
                                  decoration: InputDecoration(labelText: 'Bilhete de Identidade'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o Bilhete de Identidade';
                                    }
                                    return null;
                                  },
                                ),

                                TextFormField(
                                  controller: passaport_usuario,
                                  decoration: InputDecoration(labelText: 'Passaporte'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, insira o Passaporte';
                                    }
                                    return null;
                                  },
                                ),


                                //----------------- SPACE ------------------- -/
                                const SizedBox(height: 40,),

                                //------------ BUTTON SEND ---------------- -/
                                Container(
                                  height: MediaQuery.of(context).size.height / 12,
                                  width: MediaQuery.of(context).size.width / 1.2,
                                  decoration: BoxDecoration(
                                    color: ConstantColor.colorPrimary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.hovered))
                                            return ConstantColor.colorPrimary.withOpacity(0.04);
                                          if (states.contains(MaterialState.focused) ||
                                              states.contains(MaterialState.pressed))
                                            return ConstantColor.colorClickButton;
                                          return null; // Defer to the widget's default.
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        usuarioProvider.editarUsuario(
                                            widget.id_usuario, _pickedImage_usuario!, nome_usuario!.text,
                                            sobrenome_usuario!.text, passaport_usuario!.text,
                                            bi_usuario!.text, telefone_usuario!.text);
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        'Editar',
                                        style: GoogleFonts.cormorantGaramond(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: ConstantColor.whiteColor),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                });
              },
              child: const Icon(
                Icons.edit,
                color: ConstantColor.blackColor,
                size: 30,
              ),
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    maxRadius: 25,
                    minRadius: 25,
                    backgroundImage: NetworkImage(
                      widget.foto_usuario,
                    ),
                  ),


                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text(
                        widget.nome_usuario + ' ' + widget.sobrenome_usuario,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.blackColor,
                        ),
                      ),

                      Text(
                        widget.telefone_usuario,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.colorClickButton,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [

                          const Icon(
                            Icons.email,
                            color: ConstantColor.colorClickButton,
                          ),

                          SizedBox(
                            width: 10,
                          ),


                          Text(
                            widget.email_usuario,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ConstantColor.blackColor,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: ConstantColor.colorPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Verificar",
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ConstantColor.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

          Divider(
            height: 50,
            thickness: 10,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Locais Favoritos",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
          ),

          SizedBox(
            height: 20,
          ),

          ListTile(
            leading: const Icon(Icons.home_filled),
            title: Text(
              "Insere a morada de casa",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),

            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: Text(
              "Insere a morada de trabalho",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
            onTap: () {},
          ),

          Divider(
            height: 50,
            thickness: 10,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Idioma",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),

                Text(
                  "Portugues",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.colorClickButton,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 30,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Preferências de comunicação",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
          ),

          Divider(
            height: 50,
            thickness: 10,
          ),


          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(
              "Sair",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
            onTap: () => _alertDialog(context, usuarioProvider),
          ),

        ],
      ),
    );
  }

  _alertDialog(BuildContext context, AuthProvider authProvider) {
    var alertStyle = AlertStyle(
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),

        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: ConstantColor.colorPrimary,
      ),
    );

    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.warning,
      title: "Alerta",
      desc: "De certeza que quer sair?",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ConstantColor.colorFacebook,
            ),
          ),
          onPressed: () {
            authProvider.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const RegisterLoginScreen(),
              ),
            );
          },
          color: ConstantColor.whiteColor,
        ),
        DialogButton(
          splashColor: ConstantColor.whiteColor,
          highlightColor: ConstantColor.whiteColor,
          onPressed: () {
            Navigator.pop(context);
          },
          color: ConstantColor.colorFacebook,
          child: Text(
            "Cancelar",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ConstantColor.whiteColor,
              ),
          ),
        )
      ],
    ).show();
  }
}
