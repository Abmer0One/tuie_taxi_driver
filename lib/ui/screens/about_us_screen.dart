import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          foregroundColor: ConstantColor.blackColor,
          backgroundColor: ConstantColor.whiteColor,
          elevation: 0,
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                'Sobre',
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.blackColor,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 40),
              child: Text(
                'Versão AO.19.01',
                style: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.colorClickButton,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.star_border_outlined),
              title: Text(
                "Classificar a app",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.blackColor,
                ),

              ),
              onTap: () {},
            ),

            Divider(),


            ListTile(
              leading: const Icon(Icons.favorite_border_rounded),
              title: Text(
                "Segue-nos no Facebook",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.blackColor,
                ),

              ),
              onTap: () {},
            ),

            Divider(),


            ListTile(
              leading: const Icon(Icons.work_outline),
              title: Text(
                "Soluções para viagens em trabalho",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.blackColor,
                ),

              ),
              onTap: () {},
            ),

            Divider(),

            ListTile(
              leading: const Icon(Icons.work_history_outlined),
              title: Text(
                "Trabalhar na Tuié",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.blackColor,
                ),

              ),
              onTap: () {},
            ),

            Divider(),

            ListTile(
              leading: const Icon(Icons.assured_workload_outlined),
              title: Text(
                "Informação Legal",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.blackColor,
                ),

              ),
              onTap: () {},
            ),

            Divider(),


            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08,),
              child: ListTile(
                leading: const Icon(Icons.note),
                title: Text(
                  "Reconhecimentos",
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
                onTap: () {},
              ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Feito com ',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),

                const Icon(Icons.favorite, color: Colors.red,),

                Text(
                    ' em Angola',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
              ],
            )

          ],
        ),

      ),
    );
  }
}
