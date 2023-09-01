import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';

class ConexaoEstadoInternet extends StatelessWidget {
  ConexaoEstadoInternet({Key? key, required this.estado_internet}) : super(key: key);
  bool estado_internet;
  @override
  Widget build(BuildContext context) {
    return estado_internet ?
    Text(
      '',
      style: GoogleFonts.quicksand(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: ConstantColor.blackColor,
      ),
    )
        :
    Positioned(
      top: MediaQuery.of(context).size.height / 9,
      left: MediaQuery.of(context).size.width / 8,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ConstantColor.colorPrimary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 50,
              color: ConstantColor.whiteColor,
            ),
            Text(
              'Estas Offline, Conecte-se a internet.',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: ConstantColor.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
