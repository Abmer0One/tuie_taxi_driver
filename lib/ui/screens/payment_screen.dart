import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';
import 'package:tuie_driver_taxi/ui/screens/add_card_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
              'Pagamento',
              style: GoogleFonts.quicksand(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ConstantColor.colorLigth,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo Tuié',
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: ConstantColor.colorClickButton,
                  ),
                ),

                Text(
                  '0 Kz',
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.colorLigth,
                  ),
                ),

                Divider(),

                Text(
                  'O saldo da Tuié está disponível com este metodo de pagamento',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: ConstantColor.blackColor,
                  ),
                ),

              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.question_mark_outlined),
            title: Text(
              "O que é o saldo da Tuié?",
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
            leading: const Icon(Icons.access_time),
            title: Text(
              "Ver transações",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
            onTap: () {},
          ),


          Divider(
            height: 50,
            thickness: 20,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Métodos de Pagamento',
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
          ),

          ListTile(
            leading: const Icon(
              Icons.money_sharp,
              color: Colors.green,
            ),
            title: Text(
              "Em Dinheiro",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: ConstantColor.blackColor,
              ),
            ),
            onTap: () {},
          ),

          Divider(),

          ListTile(
            leading: const Icon(Icons.credit_card),
            title: Text(
              "Adicionar Cartão",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: ConstantColor.blackColor,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const AddCardScreen()
                  //
                  //ProductPage
                ),
              );
            },
          ),

          Divider(
            height: 40,
            thickness: 10,
          ),


        ],
      ),
    );
  }
}
