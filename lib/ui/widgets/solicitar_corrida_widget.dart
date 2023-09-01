import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';
import 'package:tuie_driver_taxi/constants/constant_variable.dart';
import 'package:tuie_driver_taxi/provider/corrida_provider.dart';
import 'package:tuie_driver_taxi/provider/localizacao_provider.dart';
import 'package:tuie_driver_taxi/provider/tipo_de_servico_provider.dart';

class SolicitarCorridaWidget extends StatefulWidget {
  SolicitarCorridaWidget({
    Key? key,
    required this.ponto_de_partida,
    required this.ponto_de_destino,
    required this.nome_passageiro,
    required this.sobrenome_passageiro,
    required this.telefone_passageiro,
    required this.email_passageiro,
    required this.latitude_origem,
    required this.longitude_origem,
    required this.latitude_destino,
    required this.longitude_destino,
  }) : super(key: key);
  String ponto_de_partida;
  String ponto_de_destino;
  String nome_passageiro;
  String sobrenome_passageiro;
  String telefone_passageiro;
  String email_passageiro;
  double latitude_origem;
  double longitude_origem;
  double latitude_destino;
  double longitude_destino;
  @override
  State<SolicitarCorridaWidget> createState() => _SolicitarCorridaWidgetState();
}

class _SolicitarCorridaWidgetState extends State<SolicitarCorridaWidget> {


  @override
  Widget build(BuildContext context) {
    final corridaProvider = Provider.of<CorridaProvider>(context);
    final tipoDeServicoProvider = Provider.of<TipoDeServicoProvider>(context);
    final localizacaoProvider = Provider.of<LocalizacaoProvider>(context);
    corridaProvider.fetchLastRun();
   // ConstantVariable.corrida_solicitada = false;
    localizacaoProvider.calculateDistance(
      widget.latitude_origem,
      widget.longitude_origem,
      widget.latitude_destino,
      widget.longitude_destino,    // Substitua pelas coordenadas de destino
    );
    return Positioned(
      bottom: 0.1,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.09,
        decoration: BoxDecoration(
            color: ConstantColor.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MediaQuery.of(context).size.height * 0.02),
                topRight: Radius.circular(MediaQuery.of(context).size.height * 0.02)
            ),
            border: Border.all(
              width: 1,
              color: ConstantColor.colorPrimary,
              style: BorderStyle.solid
            )
        ),
        child: Column(
          children: [

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: 5,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: ConstantColor.colorClickButton,
                  ),
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Sua viagem...',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                ),
              ),
            ),



            Consumer<LocalizacaoProvider>(
              builder: (context, distanceProvider, child) {
                ConstantVariable.kilometro = distanceProvider.calculatedDistance;
                return Text(
                  'Distância de ${distanceProvider.calculatedDistance.toStringAsFixed(1)}Km',
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ConstantColor.blackColor,
                  ),
                );
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_history,
                  color: ConstantColor.redColor,
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    widget.ponto_de_partida,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ConstantColor.blackColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_history,
                  color: ConstantColor.redColor,
                ),

                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    widget.ponto_de_destino,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ConstantColor.blackColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),



            ConstantVariable.corrida_solicitada ? Container() :
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: tipoDeServicoProvider.getTipoDeServicosStream(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return Center(child: LoadingAnimationWidget.fourRotatingDots(
                      size: MediaQuery.of(context).size.width * 0.04, color: ConstantColor.blackColor,
                    ),);
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text(
                      'Erro ao carregar os serviços',
                      style: GoogleFonts.quicksand(
                          color: ConstantColor.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.02
                      ),
                    )
                    );
                  }
                  final servicos = snapshot.data!.docs;
                  return servicos == null ? Container() : ListView.builder(
                    itemCount: servicos.length,
                    itemBuilder: (context, index) {
                      final servico = servicos[index];
                      int totalConforto = tipoDeServicoProvider.calculateTotal(
                        ConstantVariable.kilometro.toInt(),
                        servico['kilometro_inicial'],
                        servico['preco_inicial'],
                        servico['preco_adicional'],
                      );
                      ConstantVariable.valor_da_corrida = totalConforto.toString();
                      return Column(
                        children: [
                          !ConstantVariable.corrida_solicitada ? InkWell(
                            onTap: (){
                              setState(() {
                                ConstantVariable.pacoteSelecionado = index;
                                if(servico['descrisao'] == 'Econômico' && ConstantVariable.pacoteSelecionado == 0){
                                  ConstantVariable.corrida_economica = true;
                                  ConstantVariable.corrida_confortavel  = false;
                                } else if(servico['descrisao'] == 'Conforto' && ConstantVariable.pacoteSelecionado == 1){
                                  ConstantVariable.corrida_economica = false;
                                  ConstantVariable.corrida_confortavel  = true;
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ConstantColor.colorPrimary,
                                  border: Border.all(color: ConstantColor.colorPrimary)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [

                                      Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: index == 0 && ConstantVariable.corrida_economica ? ConstantColor.whiteColor :
                                          index == 1 && ConstantVariable.corrida_confortavel ? ConstantColor.whiteColor : ConstantColor.colorPrimary,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(90),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: index == 0 && ConstantVariable.corrida_economica ? ConstantColor.whiteColor :
                                              index == 1 && ConstantVariable.corrida_confortavel ? ConstantColor.whiteColor : ConstantColor.colorPrimary,
                                              blurRadius: 15,
                                              offset: Offset(0, 8),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                                      Text(
                                        servico['descrisao'],
                                        style: GoogleFonts.quicksand(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: ConstantColor.whiteColor,
                                        ),
                                      ),




                                    ],
                                  ),

                                  Text(
                                    totalConforto.toStringAsFixed(2)+'Kz',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ConstantColor.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ) : Container(),

                          /*  !ConstantVariable.corrida_solicitada ? InkWell(
                            onTap: (){
                              setState(() {
                                ConstantVariable.corrida_economica = false;
                                ConstantVariable.corrida_confortavel = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ConstantVariable.corrida_confortavel ? ConstantColor.colorPrimary : ConstantColor.whiteColor,
                                  border: Border.all(color: ConstantColor.colorPrimary)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Conforto',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ConstantVariable.corrida_confortavel ? ConstantColor.whiteColor : ConstantColor.colorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ) : Container(),*/
                        ],
                      );
                    },
                  );
                },
              ),
            ),



            ConstantVariable.corrida_economica || ConstantVariable.corrida_confortavel ?
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.09,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ConstantColor.colorPrimary,
                  border: Border.all(color: ConstantColor.colorPrimary)
              ),
              child: InkWell(
                onTap: (){
                  ConstantVariable.corrida_solicitada = true;
                  ConstantVariable.corrida_economica = false;
                  ConstantVariable.corrida_confortavel  = false;
                },
                child: Container(
                  child: Center(
                    child: Text(
                      "Solicitar",
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ConstantColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ) :
            ConstantVariable.corrida_solicitada ? Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                children: [

                  Text(
                    'Corrida ${corridaProvider.lastRun!['estado_corrida']}',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: ConstantColor.blackColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    'Procurando um motorista para si...',
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ConstantColor.blackColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  corridaProvider.lastRun!['estado_corrida'] == 'Aceite' ? Container()
                      : LoadingAnimationWidget.discreteCircle(
                    color: ConstantColor.blackColor,
                    size: 30,
                  ),
                ],
              ),
            ) : Container(),

          ],
        ),
      )
    );
  }
}
