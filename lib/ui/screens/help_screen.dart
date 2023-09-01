import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {


  String Sentence = '	Lorem ipsum sem habitasse morbi enim sed consectetur, class accumsan blandit vulputate faucibus euismod, '
      'tempus purus habitant vehicula iaculis adipiscing. quam rutrum sem cubilia laoreet volutpat sed, sociosqu orci imperdiet tempor'
      ' hendrerit, molestie ultricies platea et tristique. nam mattis fames himenaeos quam dapibus at nec nisi, amet quisque tellus feugiat'
      ' fringilla tellus nam ligula, neque torquent praesent';
  bool isExpandedInbox = true;
  bool isExpandedAboutTuie = true;
  bool isExpandedAppFuntion = true;
  bool isExpandedAcountData = true;
  bool isExpandedPayment = true;
  bool isExpandedUseTuie = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.whiteColor,
      appBar: AppBar(
        foregroundColor: ConstantColor.blackColor,
        backgroundColor: ConstantColor.whiteColor,
        elevation: 5,
        title: Text(
            "Obter ajuda",
            style: GoogleFonts.quicksand(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ConstantColor.blackColor,
            ),
        ),
      ),


      body:  ListView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [

          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1, left: 20),
            child: Text(
              "Como podemos ajudar?",
              style: GoogleFonts.quicksand(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top:10, left: 20),
            child: Text(
              "Pedidos de assistência",
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
          ),

          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isExpandedInbox = !isExpandedInbox;
              });
            },
            child: AnimatedContainer(
              margin: EdgeInsets.symmetric(
                horizontal: isExpandedInbox ? 15 : 0,
                vertical: 10,
              ),
              padding: const EdgeInsets.all(10),
              height: isExpandedInbox ? MediaQuery.of(context).size.height * 0.1 : 430,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 1200),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: ConstantColor.whiteColor,
                    blurRadius: 0,
                  ),
                ],
                color: ConstantColor.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(isExpandedInbox ? 0 : 0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      const Icon(Icons.message, color: ConstantColor.blackColor,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Caixa de Entrada',
                            style: GoogleFonts.quicksand(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ConstantColor.blackColor,
                            ),
                          ),

                          Text(
                            'Ver conversas abertas',
                            style: GoogleFonts.quicksand(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ConstantColor.colorLigth,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        isExpandedInbox
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: ConstantColor.blackColor,
                        size: 27,
                      ),
                    ],
                  ),
                  isExpandedInbox ? const SizedBox() : const SizedBox(height: 20),
                  AnimatedCrossFade(
                    firstChild: Text(
                      '',
                      style: GoogleFonts.quicksand(
                        fontSize: 0,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.colorClickButton,
                      ),
                    ),
                    secondChild: Text(
                      Sentence,
                      style: const TextStyle(
                        color: ConstantColor.blackColor,
                        fontSize: 15.7,
                      ),
                    ),
                    crossFadeState: isExpandedInbox
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 1200),
                    reverseDuration: Duration.zero,
                    sizeCurve: Curves.fastLinearToSlowEaseIn,
                  ),
                ],
              ),
            ),
          ),


          Padding(
            padding: EdgeInsets.only(top:10, left: 20),
            child: Text(
              "Obter ajuda com outros assuntos",
              style: GoogleFonts.quicksand(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ConstantColor.blackColor,
              ),
            ),
          ),

          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isExpandedAboutTuie = !isExpandedAboutTuie;
              });
            },
            child: AnimatedContainer(
              margin: EdgeInsets.symmetric(
                horizontal: isExpandedAboutTuie ? 15 : 0,
                vertical: 10,
              ),
              padding: const EdgeInsets.all(10),
              height: isExpandedAboutTuie ? MediaQuery.of(context).size.height * 0.1 : 430,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 1200),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: ConstantColor.whiteColor,
                    blurRadius: 0,
                  ),
                ],
                color: ConstantColor.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(isExpandedAboutTuie ? 0 : 0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        'Sobre a Tuié',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.blackColor,
                        ),
                      ),
                      Icon(
                        isExpandedAboutTuie
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: ConstantColor.blackColor,
                        size: 27,
                      ),
                    ],
                  ),
                  Divider(),
                  isExpandedAboutTuie ? const SizedBox() : const SizedBox(height: 20),
                  AnimatedCrossFade(
                    firstChild: Text(
                      '',
                      style: GoogleFonts.quicksand(
                        fontSize: 0,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.colorClickButton,
                      ),
                    ),
                    secondChild: Text(
                      Sentence,
                      style: const TextStyle(
                        color: ConstantColor.blackColor,
                        fontSize: 15.7,
                      ),
                    ),
                    crossFadeState: isExpandedAboutTuie
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 1200),
                    reverseDuration: Duration.zero,
                    sizeCurve: Curves.fastLinearToSlowEaseIn,
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isExpandedAppFuntion = !isExpandedAppFuntion;
              });
            },
            child: AnimatedContainer(
              margin: EdgeInsets.symmetric(
                horizontal: isExpandedAppFuntion ? 15 : 0,
                vertical: 10,
              ),
              padding: const EdgeInsets.all(10),
              height: isExpandedAppFuntion ? MediaQuery.of(context).size.height * 0.1 : 430,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 1200),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: ConstantColor.whiteColor,
                    blurRadius: 0,
                  ),
                ],
                color: ConstantColor.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(isExpandedAppFuntion ? 0 : 0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        'App e Funções',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.blackColor,
                        ),
                      ),
                      Icon(
                        isExpandedAppFuntion
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: ConstantColor.blackColor,
                        size: 27,
                      ),
                    ],
                  ),
                  Divider(),
                  isExpandedAppFuntion ? const SizedBox() : const SizedBox(height: 20),
                  AnimatedCrossFade(
                    firstChild: Text(
                      '',
                      style: GoogleFonts.quicksand(
                        fontSize: 0,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.colorClickButton,
                      ),
                    ),
                    secondChild: Text(
                      Sentence,
                      style: const TextStyle(
                        color: ConstantColor.blackColor,
                        fontSize: 15.7,
                      ),
                    ),
                    crossFadeState: isExpandedAppFuntion
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 1200),
                    reverseDuration: Duration.zero,
                    sizeCurve: Curves.fastLinearToSlowEaseIn,
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isExpandedAcountData = !isExpandedAcountData;
              });
            },
            child: AnimatedContainer(
              margin: EdgeInsets.symmetric(
                horizontal: isExpandedAcountData ? 15 : 0,
                vertical: 10,
              ),
              padding: const EdgeInsets.all(10),
              height: isExpandedAcountData ? MediaQuery.of(context).size.height * 0.1 : 430,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 1200),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: ConstantColor.whiteColor,
                    blurRadius: 0,
                  ),
                ],
                color: ConstantColor.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(isExpandedAcountData ? 0 : 0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        'Conta e Dados',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.blackColor,
                        ),
                      ),
                      Icon(
                        isExpandedAcountData
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: ConstantColor.blackColor,
                        size: 27,
                      ),
                    ],
                  ),
                  Divider(),
                  isExpandedAcountData ? const SizedBox() : const SizedBox(height: 20),
                  AnimatedCrossFade(
                    firstChild: Text(
                      '',
                      style: GoogleFonts.quicksand(
                        fontSize: 0,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.colorClickButton,
                      ),
                    ),
                    secondChild: Text(
                      Sentence,
                      style: const TextStyle(
                        color: ConstantColor.blackColor,
                        fontSize: 15.7,
                      ),
                    ),
                    crossFadeState: isExpandedAcountData
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 1200),
                    reverseDuration: Duration.zero,
                    sizeCurve: Curves.fastLinearToSlowEaseIn,
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isExpandedPayment = !isExpandedPayment;
              });
            },
            child: AnimatedContainer(
              margin: EdgeInsets.symmetric(
                horizontal: isExpandedPayment ? 15 : 0,
                vertical: 10,
              ),
              padding: const EdgeInsets.all(10),
              height: isExpandedPayment ? MediaQuery.of(context).size.height * 0.1 : 430,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 1200),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: ConstantColor.whiteColor,
                    blurRadius: 0,
                  ),
                ],
                color: ConstantColor.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(isExpandedPayment ? 0 : 0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        'Tarifas e Pagamentos',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.blackColor,
                        ),
                      ),
                      Icon(
                        isExpandedPayment
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: ConstantColor.blackColor,
                        size: 27,
                      ),
                    ],
                  ),
                  Divider(),
                  isExpandedPayment ? const SizedBox() : const SizedBox(height: 20),
                  AnimatedCrossFade(
                    firstChild: Text(
                      '',
                      style: GoogleFonts.quicksand(
                        fontSize: 0,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.colorClickButton,
                      ),
                    ),
                    secondChild: Text(
                      Sentence,
                      style: const TextStyle(
                        color: ConstantColor.blackColor,
                        fontSize: 15.7,
                      ),
                    ),
                    crossFadeState: isExpandedPayment
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 1200),
                    reverseDuration: Duration.zero,
                    sizeCurve: Curves.fastLinearToSlowEaseIn,
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isExpandedUseTuie = !isExpandedUseTuie;
              });
            },
            child: AnimatedContainer(
              margin: EdgeInsets.symmetric(
                horizontal: isExpandedUseTuie ? 15 : 0,
                vertical: 10,
              ),
              padding: const EdgeInsets.all(10),
              height: isExpandedUseTuie ? MediaQuery.of(context).size.height * 0.1 : 430,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: const Duration(milliseconds: 1200),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: ConstantColor.whiteColor,
                    blurRadius: 0,
                  ),
                ],
                color: ConstantColor.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(isExpandedUseTuie ? 0 : 0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        'A usar a Tuié',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ConstantColor.blackColor,
                        ),
                      ),
                      Icon(
                        isExpandedUseTuie
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: ConstantColor.blackColor,
                        size: 27,
                      ),
                    ],
                  ),
                  Divider(),
                  isExpandedUseTuie ? const SizedBox() : const SizedBox(height: 20),
                  AnimatedCrossFade(
                    firstChild: Text(
                      '',
                      style: GoogleFonts.quicksand(
                        fontSize: 0,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.colorClickButton,
                      ),
                    ),
                    secondChild: Text(
                      Sentence,
                      style: const TextStyle(
                        color: ConstantColor.blackColor,
                        fontSize: 15.7,
                      ),
                    ),
                    crossFadeState: isExpandedUseTuie
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 1200),
                    reverseDuration: Duration.zero,
                    sizeCurve: Curves.fastLinearToSlowEaseIn,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),

    );
  }

}
