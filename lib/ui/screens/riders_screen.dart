import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';
import 'package:tuie_driver_taxi/provider/corrida_provider.dart';


class RidersScreen extends StatefulWidget {
  RidersScreen({Key? key, required this.telefone_passageiro}) : super(key: key);
  String telefone_passageiro;

  @override
  State<RidersScreen> createState() => _RidersScreenState();
}

class _RidersScreenState extends State<RidersScreen> {


  @override
  Widget build(BuildContext context) {
    final corridaProvider = Provider.of<CorridaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ConstantColor.blackColor,
        backgroundColor: ConstantColor.whiteColor,
        elevation: 0,
        title: Text(
          'Viagens',
          style: GoogleFonts.quicksand(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: ConstantColor.blackColor,
          ),
        )
      ),

     body: FutureBuilder<List<DocumentSnapshot>>(
       future: corridaProvider.getCorridas(widget.telefone_passageiro),
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return CircularProgressIndicator();
         } else if (snapshot.hasError) {
           return Text('Error: ${snapshot.error}');
         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
           return Text('No rides found for the passenger.');
         } else {
           final rides = snapshot.data!;

           return ListView.builder(
             itemCount: rides.length,
             itemBuilder: (context, index) {
               final ride = rides[index];
               final corrida = ride.data() as Map<String, dynamic>;
               //final formattedDate = DateFormat('yyyy-MM-dd').format(corrida['data_corrida']);
               return snapshot.hasData == 0 ?
               Container(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     Text('Não existe nenhuma corrida.'),

                     SizedBox(
                       height: 40,
                       width: 40,
                       child: Center(
                         child: LoadingAnimationWidget.discreteCircle(
                           color: ConstantColor.whiteColor,
                           size: 30,
                         ),
                       ),
                     ),

                   ],
                 ),
               )
                   :
               Container(
                 height: MediaQuery.of(context).size.height * 0.1,
                 margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   color: ConstantColor.colorLigth,
                   borderRadius: BorderRadius.circular(5),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Container(
                           width: MediaQuery.of(context).size.width * 0.5,
                           child: Text(
                               corrida['ponto_partida'],
                               style: GoogleFonts.quicksand(
                                 fontSize: 14,
                                 fontWeight: FontWeight.bold,
                                 color: ConstantColor.blackColor,
                               ),
                               overflow: TextOverflow.ellipsis
                           ),
                         ),


                         Container(
                           width: MediaQuery.of(context).size.width * 0.5,
                           child: Text(
                               corrida['ponto_destino'],
                               style: GoogleFonts.quicksand(
                                 fontSize: 14,
                                 fontWeight: FontWeight.bold,
                                 color: ConstantColor.blackColor,
                               ),
                               overflow: TextOverflow.ellipsis
                           ),
                         ),

                       ],
                     ),

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Row(
                           children: [

                             Text(
                               corrida['valor_total_corrida'] + 'Kz',
                               style: GoogleFonts.quicksand(
                                 fontSize: 14,
                                 fontWeight: FontWeight.bold,
                                 color: ConstantColor.blackColor,
                               ),
                             ),
                           ],
                         ),

                         Container(
                           width: MediaQuery.of(context).size.width * 0.3,
                           child: Text(
                               corrida['data_corrida'],
                               style: GoogleFonts.quicksand(
                                 fontSize: 14,
                                 fontWeight: FontWeight.bold,
                                 color: ConstantColor.blackColor,
                               ),
                               overflow: TextOverflow.ellipsis
                           ),
                         ),

                       ],
                     ),
                   ],
                 ),
               );
             },
           );
         }
       },
     ),

     /* body: FutureBuilder<List>(
            future: CorridaDatabase().pegarCorridaPassageiroSolicitada(widget.id_passageiro),
            builder: (context, snapshot){
              if(snapshot.hasError){
                print("error");
              }
              if(snapshot.hasData){
                //ListRacing(list: snapshot.data as List);
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.hasData == null ? 0 : snapshot.data!.length,
                  padding: EdgeInsets.only(left: 10),
                  itemBuilder: (context, index){
                    return snapshot.hasData == 0 ?
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Não existe nenhuma corrida.'),

                          SizedBox(
                              height: 40,
                              width: 40,
                              child: Center(
                                child: LoadingAnimationWidget.discreteCircle(
                                  color: ConstantColor.whiteColor,
                                  size: 30,
                                ),
                              ),
                          ),

                        ],
                      ),
                    )
                        :
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ConstantColor.colorLigth,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  snapshot.data![index]['ponto_partida'],
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantColor.blackColor,
                                  ),
                                  overflow: TextOverflow.ellipsis
                                ),
                              ),


                              Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                                  snapshot.data![index]['ponto_destino'],
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantColor.blackColor,
                                  ),
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),

                            ],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [

                                  Text(
                                    snapshot.data![index]['valor_total_corrida'] + 'Kz',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ConstantColor.blackColor,
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  snapshot.data![index]['data_corrida'],
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantColor.blackColor,
                                  ),
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: ConstantColor.whiteColor,
                  size: 30,
                ),
              );
            },
          ),*/
    );
  }







}
