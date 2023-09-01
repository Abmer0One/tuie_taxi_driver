import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({Key? key}) : super(key: key);

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.whiteColor,
      appBar: AppBar(
        foregroundColor: ConstantColor.blackColor,
        backgroundColor: ConstantColor.whiteColor,
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Promoções',
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ConstantColor.whiteColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor: ConstantColor.colorLigth,
                prefixIcon: const Icon(
                  Icons.card_giftcard_outlined,
                  color: ConstantColor.blackColor,
                ),
                hintText: 'Introduz o código promocional',
                hintStyle: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ConstantColor.blackColor,
                ),
              ),
              onTap: (){

              },
            ),
          ),

          Divider(
            height: 50,
            thickness: 10,
          ),

        ],
      ),
    );
  }
}
