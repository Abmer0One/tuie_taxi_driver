import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: ConstantColor.whiteColor,
      appBar: AppBar(
        foregroundColor: ConstantColor.blackColor,
        backgroundColor: ConstantColor.whiteColor,
        elevation: 0,
        title: Text(
          'Novo Cartão',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ConstantColor.blackColor,
          ),
        ),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ConstantColor.colorPrimary,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor: ConstantColor.colorLigth,
                prefixIcon: const Icon(
                  Icons.credit_card,
                  color: ConstantColor.blackColor,
                ),
                hintText: 'Número do Cartão',
                hintStyle: GoogleFonts.quicksand(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.blackColor,
                ),
              ),
              onTap: (){

              },
            ),
          ),


         Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: ConstantColor.colorLigth,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ConstantColor.transparentColor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: 'Validade',
                    hintStyle: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ConstantColor.colorClickButton,
                    ),
                  ),
                  onTap: (){

                  },
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width / 2.5,
                decoration: BoxDecoration(
                  color: ConstantColor.colorLigth,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ConstantColor.transparentColor,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    fillColor: ConstantColor.colorLigth,
                    hintText: 'CVV',
                    hintStyle: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ConstantColor.colorClickButton,
                    ),
                  ),
                  onTap: (){

                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4, left: 20, right: 20, bottom: 10),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: ConstantColor.colorClickButton,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'A Tuié poderá cobrar uma pequena quantia (que será imediatamente reembolsada) para confirmar os dados do cartão.',
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: ConstantColor.colorClickButton,
                    ),
                  ),

                  TextSpan(
                    text: ' Saber mais',
                    style: GoogleFonts.quicksand(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.colorPrimary,
                        decoration: TextDecoration.none
                    ),
                  ),
                ],
              ),
            ),
          ),


          //------------ BUTTON ADD ---------------- -/
          Container(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width / 1.2,
            decoration: BoxDecoration(
              color: ConstantColor.colorLigth,
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
              onPressed: () {
              },
              child: Center(
                child: Text(
                  'Adicionar cartão',
                  style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ConstantColor.colorClickButton),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
