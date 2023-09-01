
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';
import 'package:tuie_driver_taxi/constants/constant_variable.dart';
import 'package:tuie_driver_taxi/provider/provider_autenticacao.dart';
import 'package:tuie_driver_taxi/ui/screens/about_us_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/edit_profile_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/help_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/payment_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/promotion_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/register_login_screen.dart';
import 'package:tuie_driver_taxi/ui/screens/riders_screen.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({Key? key,}) : super(key: key);
  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {



  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<AuthProvider>(context);
    return Drawer(
      backgroundColor: ConstantColor.whiteColor,
      elevation: 5,
      child: Consumer<AuthProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.user != null) {
            return ListView(
            children: [

              Container(
                height: MediaQuery.of(context).size.height * 0.10,
                child: StreamBuilder<QuerySnapshot>(
                  stream: userProvider.getMotoristaEmailStream(userProvider.user!.email!),
                  builder: (context, snapshot) {
                    /*if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: LoadingAnimationWidget.fourRotatingDots(
                        size: MediaQuery.of(context).size.width * 0.02, color: ConstantColor.blackColor,
                      ),);
                    }*/
                    if (!snapshot.hasData) {
                      return Center(child: LoadingAnimationWidget.fourRotatingDots(
                        size: MediaQuery.of(context).size.width * 0.04, color: ConstantColor.blackColor,
                      ),);
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erro ao carregar os dados do Usuario',
                          style: GoogleFonts.cormorantGaramond(
                            color: ConstantColor.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      );
                    }
                    final motoristas = snapshot.data!.docs;
                    return motoristas == null ? Container() : ListView.builder(
                      itemCount: motoristas.length,
                      itemBuilder: (context, index) {
                        final motorista = motoristas[index];
                        ConstantVariable.id_motorista = motorista.id;
                        ConstantVariable.telefone_motorista = motorista['telefone_motorista'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                maxRadius: 25,
                                minRadius: 25,
                                backgroundImage: NetworkImage(
                                    motorista['foto_motorista']
                                ),
                              ),

                              SizedBox(
                                width: 10,
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    motorista['nome_motorista'],
                                    style: GoogleFonts.cormorantGaramond(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ConstantColor.blackColor,
                                    ),
                                  ),

                                  Text(
                                    motorista['telefone_motorista'],
                                    style: GoogleFonts.cormorantGaramond(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ConstantColor.blackColor,
                                    ),
                                  ),

                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => EditProfileScreen(
                                            id_usuario: motorista.id,
                                            nome_usuario: motorista['nome_motorista'],
                                            sobrenome_usuario: motorista['sobrenome_motorista'],
                                            telefone_usuario: motorista['telefone_motorista'],
                                            password_usuario: motorista['password_motorista'],
                                            email_usuario: motorista['email_motorista'],
                                            bi_usuario: motorista['bi_motorista'],
                                            passaport_usuario: motorista['passaport_motorista'],
                                            foto_usuario: motorista['foto_motorista'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Editar perfil",
                                      style: GoogleFonts.cormorantGaramond(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ConstantColor.colorPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Divider(
                height: 50,
                thickness: 10,
              ),

              ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text(
                  "Pagamento",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const PaymentScreen()
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.card_giftcard_outlined),
                title: Text(
                  "Promoções",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const PromotionScreen()
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.run_circle_rounded),
                title: Text(
                  "Minhas Viagens",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RidersScreen(
                            telefone_passageiro: ConstantVariable.telefone_motorista
                        ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.question_mark_outlined),
                title: Text(
                  "Ajuda",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const HelpScreen()
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: Text(
                  "Sobre Nós",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const AboutUsScreen()
                      //
                      //ProductPage
                    ),
                  );
                },
              ),
              Divider(
                height: 50,
                thickness: 10,
              ),


              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  "Sair",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
                onTap: () {
                  usuarioProvider.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const RegisterLoginScreen(),
                    ),
                  );
                },
              ),

            ],
          );
          } else {
            return const RegisterLoginScreen();
          }
        }
      ),
    );
  }
}
