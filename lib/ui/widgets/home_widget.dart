import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuie_driver_taxi/constants/constant_color.dart';
import 'package:tuie_driver_taxi/constants/constant_variable.dart';
import 'package:tuie_driver_taxi/model/localizacao_model.dart';
import 'package:tuie_driver_taxi/provider/corrida_provider.dart';
import 'package:tuie_driver_taxi/provider/localizacao_provider.dart';
import 'package:tuie_driver_taxi/provider/provider_autenticacao.dart';
import 'package:tuie_driver_taxi/ui/screens/register_login_screen.dart';
import 'package:tuie_driver_taxi/ui/widgets/conexao_internet_widget.dart';
import 'package:tuie_driver_taxi/ui/widgets/solicitar_corrida_widget.dart';

import '../screens/home_screen.dart';


class HomeWidget extends StatefulWidget {
  HomeWidget({Key? key,required this.scaffoldKey,}) : super(key: key);
  GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}


class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin{

  double _percent = 0.0;

  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController? mapController; //controller for Google map
  List<LatLng> polylineCoordinatess = [];
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  bool localizacao = false;

  bool isChecked = false;
  Duration _duration = const Duration(milliseconds: 370);
  Animation<Alignment>? _animation;
  AnimationController? _animationController;

  final FlutterNetworkConnectivity _flutterNetworkConnectivity = FlutterNetworkConnectivity(
    isContinousLookUp: true,
    // optional, false if you cont want continous lookup.
    lookUpDuration: const Duration(seconds: 5),
    // optional, to override default lookup duration.
    // lookUpUrl: 'example.com', // optional, to override default lookup url
  );

  //bool? _isInternetAvailableOnCall;
  bool _isInternetAvailableStreamStatus = false;

  StreamSubscription<bool>? _networkConnectionStream;

  //********************** INITSTATE ********************** */
  @override
  void initState() {
    super.initState();
    _flutterNetworkConnectivity.getInternetAvailabilityStream().listen((event) {
      _isInternetAvailableStreamStatus = event;
     // updateCurrentLocation();
      setState(() {
        !localizacao ? updateCurrentLocation() : null;
        localizacao = true;
      });
    });
    init();
    _animationController = AnimationController(vsync: this, duration: _duration);
    _animation = AlignmentTween(begin: Alignment.centerLeft, end: Alignment.centerRight)
      .animate(
        CurvedAnimation(
          parent: _animationController!,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn,
        ),
      );
  }


  @override
  void dispose() {
    _networkConnectionStream?.cancel();
    _flutterNetworkConnectivity.unregisterAvailabilityListener();
    _animationController!.dispose();
    super.dispose();
  }

  void init() async {
    await _flutterNetworkConnectivity.registerAvailabilityListener();

  }



  updateCurrentLocation() async {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      ConstantVariable.initialCameraPosition = CameraPosition(zoom: 16, target: LatLng(position.latitude, position.longitude));
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        ConstantVariable.initialCameraPosition,
      ));
     // notifyListeners();

  }

  _offOnline(double latitude, double longitude){
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Center(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(
                    () {
                  if (_animationController!.isCompleted) {
                    _animationController!.reverse();
                  } else {
                    _animationController!.forward();
                  }
                  isChecked = !isChecked;
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                  decoration: BoxDecoration(
                    color: isChecked ? Colors.green : Colors.red,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(99),
                    ),
                   /* boxShadow: [
                      BoxShadow(
                        color: isChecked
                            ? Colors.green.withOpacity(0.6)
                            : Colors.red.withOpacity(0.6),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],*/
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: _animation!.value,
                        child: GestureDetector(
                          onTap: () {
                            setState(
                                  () {
                                if (_animationController!.isCompleted) {
                                  _animationController!.reverse();
                                } else {
                                  _animationController!.forward();
                                }
                                isChecked = !isChecked;
                              },
                            );
                          },
                          child: Center(
                            child: Icon(
                              size: 25,
                              Icons.power_settings_new_outlined,
                              color: ConstantColor.whiteColor ,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

               /* Text(
                  isChecked ? 'N' : 'FF',
                  style: GoogleFonts.cormorantGaramond(
                    fontWeight: FontWeight.bold,
                    fontSize: 42,
                    color: ConstantColor.blackColor,
                  ),
                )*/

              ],
            ),
          ),
        );
      },
    );
  }

  tracar_rota(double latitude_origem, double longitude_origem,
      double latitude_destino, double longitude_destino, List<LatLng> polylineCoordinates,
      LocalizacaoProvider localizacaoProvider) async {
    LatLng origin = LatLng(latitude_origem, longitude_origem);
    LatLng destination = LatLng(latitude_destino, longitude_destino);

    BitmapDescriptor marcador_cliente = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/client_locations.png",
    );

    BitmapDescriptor marcador_motorista = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/driver_locations.png",
    );

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      ConstantVariable.chaveAPI,
      PointLatLng(origin.latitude, origin.longitude),
      PointLatLng(destination.latitude, destination.longitude),
     // travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      polylines.clear();
      //polylineCoordinatess.clear();
      ConstantVariable.marcadores.add(Marker(
        markerId: const MarkerId("1"),
        position: LatLng(latitude_origem, longitude_origem),
        infoWindow: const InfoWindow(title: 'Partida'),
        icon: marcador_motorista,
      ));

      ConstantVariable.marcadores.add(Marker(
        markerId: const MarkerId("2"),
        position: LatLng(latitude_destino, longitude_destino),
        infoWindow: const InfoWindow(title: 'Cliente'),
        icon: marcador_cliente,
      ));
      addPolyLine(polylineCoordinates);
      context.read<LocalizacaoProvider>().setRouteCoordinates(polylineCoordinates);
    }
  }

  _getUserLocationn(double lat, double long) async{
    BitmapDescriptor marcador_origem = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/client_locations.png",
    );

      ConstantVariable.initialCameraPosition = CameraPosition(zoom: 16, target: LatLng(lat, long));
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
          ConstantVariable.initialCameraPosition,
      ));
      /*List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
      ConstantVariable.marcadores.add(
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(lat, long),
          infoWindow: const InfoWindow(title: 'Partida'),
          icon: marcador_origem,
        )
      );
      Placemark place = placemarks[0];
      ConstantVariable.onde_estou = place.street! +', ' + place.subAdministrativeArea! +', ' + place.administrativeArea!;
  */
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.lightBlue,
      points: polylineCoordinates,
      width: 4,
    );

    polylines[id] = polyline;
    setState(() {
      //polylines.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    var isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final corridaProvider = Provider.of<CorridaProvider>(context);
    final localizacaoProvider = Provider.of<LocalizacaoProvider>(context);
    //_getUserLocationn(ConstantVariable.latitude_origem, ConstantVariable.longitude_origem);
    //updateCurrentLocation();
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<LocalizacaoProvider>(
            create: (_) => LocalizacaoProvider()
        ),
      ],
      child: Consumer(builder: (context, LocalizacaoProvider locationProvider, _) {
          if (locationProvider.status == LocationProviderStatus.Loading || locationProvider.status == LocationProviderStatus.Initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (locationProvider.status == LocationProviderStatus.Success) {
            var localizacao = Provider.of<Localizacao>(context);

              ConstantVariable.latitude_origem = localizacao.latitude;
              ConstantVariable.longitude_origem = localizacao.longitude;
            isChecked ?
            corridaProvider.actualizarLocalizacaoMotorista(ConstantVariable.telefone_motorista, localizacao.latitude, localizacao.longitude)
            :
            null;
          return Consumer<AuthProvider>(
              builder: (context, userProvider, _) {
                if (userProvider.user != null) {
                  final motoristaProvider = Provider.of<AuthProvider>(context);
                  motoristaProvider.motoristaPorEmail(userProvider.user!.email!);

                  final dados_do_motorista = motoristaProvider.dados_do_motorista;
                  if(dados_do_motorista != null){
                    ConstantVariable.nome_motorista = dados_do_motorista['nome_motorista'];
                    ConstantVariable.sobrenome_motorista = dados_do_motorista['sobrenome_motorista'];
                    ConstantVariable.telefone_motorista = dados_do_motorista['telefone_motorista'];
                    ConstantVariable.email_motorista = dados_do_motorista['email_motorista'];
                    ConstantVariable.foto_motorista = dados_do_motorista['foto_motorista'];
                  }

                  return Stack(
                  children: [

                    //************************** MAP ***************************** */
                    Positioned.fill(
                      bottom: MediaQuery.of(context).size.height * 0.2,
                      child: Container(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          //myLocationEnabled: true,
                          initialCameraPosition: ConstantVariable.initialCameraPosition,
                          polylines: Set<Polyline>.of(polylines.values),
                          onMapCreated: (GoogleMapController controller) {
                            controller.moveCamera(ConstantVariable.cameraUpdate);
                            controller.setMapStyle(localizacaoProvider.createMapStyle());
                            mapController = controller;
                            mapController?.animateCamera(
                              CameraUpdate.newLatLngBounds(
                                LatLngBounds(
                                  northeast: LatLng(ConstantVariable.latitude_origem, ConstantVariable.longitude_origem),
                                  southwest: LatLng(ConstantVariable.latitude_destino, ConstantVariable.longitude_destino),
                                ),
                                30,
                              ),
                            );
                          },
                          markers: ConstantVariable.marcadores,
                          zoomControlsEnabled: false,

                        ),
                      ),
                    ),

                    //---------------------- MENU DRAWER BUTTON -----------------------
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.02,
                      left: MediaQuery.of(context).size.width * 0.02,
                      child: FloatingActionButton(
                        backgroundColor: ConstantColor.whiteColor,
                        onPressed: () => widget.scaffoldKey.currentState!.openDrawer(),
                        child: const Icon(
                          Icons.menu,
                          color: ConstantColor.blackColor,
                        ),
                      ),
                    ),

                    //---------------------- MENU LOCATION -----------------------
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.5,
                      left: MediaQuery.of(context).size.width * 0.8,
                      child: FloatingActionButton(
                        backgroundColor: ConstantColor.whiteColor,
                        onPressed: () {
                          setState(() {
                            _getUserLocationn(localizacao.latitude, localizacao.longitude);
                          });
                        },
                        child: const Icon(
                          Icons.navigation_outlined,
                          color: ConstantColor.blackColor,
                        ),
                      ),
                    ),

                    //---------------------- ALERT ONLINE OFFLINE --------------------------
                    ConexaoEstadoInternet(estado_internet: _isInternetAvailableStreamStatus),

                    //--------------- LISTAGEM DE CORRIDA ----------------------
                    Positioned(
                       /* top: MediaQuery.of(context).size.height * 0.8,
                        left: MediaQuery.of(context).size.width * 0.01,*/
                        child: NotificationListener<DraggableScrollableNotification>(
                          onNotification: (notification){
                            setState(() {
                              _percent = 2 * notification.extent - 0.6;
                            });
                            return true;
                          },
                          child: DraggableScrollableSheet(
                            maxChildSize:  0.90,
                            minChildSize: 0.2,
                            initialChildSize: 0.35,
                            builder: (_, controller) {
                              return Material(
                                elevation: 20,
                                color: ConstantColor.whiteColor,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 10),
                                  child: ConstantVariable.corrida_aceite_pelo_motorista ?
                                  _corrida_aceite(
                                    ConstantVariable.foto_passageiro,
                                    ConstantVariable.nome_passageiro, ConstantVariable.telefone_passageiro,
                                    ConstantVariable.valor_desejo_corrida, ConstantVariable.valor_da_corrida.toString(),
                                    ConstantVariable.onde_passageiro_esta, ConstantVariable.onde_passageiro_vai,
                                    ConstantVariable.latitude_origem, ConstantVariable.longitude_origem,
                                    ConstantVariable.latitude_destino, ConstantVariable.longitude_destino,
                                    corridaProvider, ConstantVariable.id_corrida
                                  )
                                    :

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                   'É bom ter você aqui.',
                                                  style: GoogleFonts.cormorantGaramond(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: ConstantColor.colorClickButton,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            _offOnline(localizacao.latitude, localizacao.longitude),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context).size.height / 5,
                                        decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          //border: Border.all(width: 1, color: Colors.black38),
                                        ),
                                        child: FutureBuilder<List<DocumentSnapshot>>(
                                          future: corridaProvider.getTodasCorridas(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Text('Error: ${snapshot.error}');
                                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                              return Center(
                                                child: LoadingAnimationWidget.discreteCircle(
                                                  color: ConstantColor.whiteColor,
                                                  size: 30,
                                                ),
                                              );
                                            } else {
                                              final rides = snapshot.data!;
                                              return isChecked ? ListView.builder(
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
                                                        const Text('Não existe nenhuma corrida.'),

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
                                                  InkWell(
                                                    onTap: () async {
                                                      List<Placemark> placemarks = await placemarkFromCoordinates(
                                                          ConstantVariable.latitude_origem,
                                                          ConstantVariable.longitude_origem
                                                      );
                                                      ConstantVariable.onde_passageiro_esta =  corrida['ponto_partida'];
                                                      ConstantVariable.onde_passageiro_vai =  corrida['ponto_destino'];
                                                      ConstantVariable.valor_desejo_corrida =  corrida['id_desejoscorrida'];
                                                      ConstantVariable.valor_da_corrida =  corrida['valor_total_corrida'];
                                                      ConstantVariable.latitude_origem = corrida['latitude_origem'];
                                                      ConstantVariable.longitude_origem = corrida['longitude_origem'];
                                                      ConstantVariable.latitude_destino = corrida['latitude_destino'];
                                                      ConstantVariable.longitude_destino = corrida['longitude_destino'];
                                                      ConstantVariable.telefone_passageiro = corrida['telefone_passageiro'];
                                                      ConstantVariable.nome_passageiro = corrida['nome_passageiro'];
                                                      ConstantVariable.foto_passageiro = corrida['foto_passageiro'];
                                                      ConstantVariable.id_corrida = ride.id;
                                                      Placemark place = placemarks[0];
                                                      ConstantVariable.onde_estou = '${place.street!}, ${place.subAdministrativeArea!}, ${place.administrativeArea!}';

                                                      // ignore: use_build_context_synchronously
                                                      showDialog(context: context, builder: (BuildContextcontext) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20.0)
                                                          ),
                                                          child: Container(
                                                            height: MediaQuery.of(context).size.height / 1.8,
                                                            width: MediaQuery.of(context).size.width - 10,
                                                            padding: const EdgeInsets.all(2),
                                                            decoration: BoxDecoration(
                                                              color: ConstantColor.whiteColor,
                                                              borderRadius: BorderRadius.circular(5),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(20),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [

                                                                  //--------------- TITLE ---------- -/
                                                                  Text(
                                                                    "Corrida Solicitada",
                                                                    style: GoogleFonts.cormorantGaramond(
                                                                        color: Colors.black,
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),

                                                                  const SizedBox(height: 10),

                                                                  //--------------- NAME -------------- -/
                                                                  Text(
                                                                    corrida['nome_passageiro'],
                                                                    style: GoogleFonts.cormorantGaramond(
                                                                        color: Colors.black,
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.bold),
                                                                  ),

                                                                  const SizedBox(height: 5,),

                                                                  //--------------- PHONE ---------------- -/
                                                                  Text(
                                                                    corrida['telefone_passageiro'],
                                                                    style: GoogleFonts.cormorantGaramond(
                                                                        color: Colors.black,
                                                                        fontSize: 20,
                                                                        fontWeight: FontWeight.normal
                                                                    ),
                                                                  ),

                                                                  const SizedBox(height: 20,),

                                                                  //--------------- ADRESS & TIME --------- -/
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          _adressTimeItem(Icons.location_on,corrida['ponto_partida'], Colors.green),
                                                                          const SizedBox(height: 10,),
                                                                          _adressTimeItem(Icons.location_on, corrida['ponto_destino'], Colors.red),
                                                                        ],
                                                                      ),

                                                                      Container(
                                                                        child: Row(
                                                                          children: [
                                                                            Text(
                                                                              corrida['valor_total_corrida'] + 'Kz',
                                                                              style: GoogleFonts.cormorantGaramond(
                                                                                  color: Colors.black,
                                                                                  fontSize:  12,
                                                                                  fontWeight: FontWeight.bold),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  const SizedBox(height: 20,),

                                                                  //---------------- WISHES -------------- -/
                                                                  Column(
                                                                    children: [
                                                                      _witches(corrida['id_desejoscorrida'], ""),
                                                                      const SizedBox(height: 20),
                                                                      _witches("Total", corrida['valor_total_corrida'] + 'Kz'),
                                                                    ],
                                                                  ),

                                                                  const SizedBox(height: 20,),

                                                                  SizedBox(
                                                                    width: MediaQuery.of(context).size.width,
                                                                    child: InkWell(
                                                                      onTap: () {
                                                                        ConstantVariable.latitude_origem = localizacao.latitude;
                                                                        ConstantVariable.longitude_origem = localizacao.longitude;
                                                                        setState((){
                                                                           tracar_rota(
                                                                              localizacao.latitude, localizacao.longitude,
                                                                              corrida['latitude_origem'], corrida['longitude_origem'],
                                                                              localizacaoProvider.routeCoordinates, localizacaoProvider
                                                                          );
                                                                           context.read<LocalizacaoProvider>().calculateDistance(
                                                                             corrida['latitude_origem'], corrida['longitude_origem'],
                                                                             corrida['latitude_destino'], corrida['longitude_destino'],    // Substitua pelas coordenadas de destino
                                                                           );
                                                                           context.read<LocalizacaoProvider>().calculateDistancePassageiro(
                                                                             localizacao.latitude, localizacao.longitude,
                                                                             corrida['latitude_origem'], corrida['longitude_origem'],    // Substitua pelas coordenadas de destino
                                                                           );
                                                                           ConstantVariable.id_corrida = ride.id;
                                                                           corridaProvider.editarEstadoCorrida(
                                                                             ride.id, 'Aceite',
                                                                             ConstantVariable.nome_motorista,
                                                                             ConstantVariable.telefone_motorista,
                                                                             localizacao.latitude, localizacao.longitude,
                                                                             ConstantVariable.onde_estou,
                                                                             ConstantVariable.foto_motorista,

                                                                           );
                                                                           ConstantVariable.corrida_aceite_pelo_motorista = true;
                                                                        });
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Container(
                                                                        width: MediaQuery.of(context).size.width * 0.4,
                                                                        height: MediaQuery.of(context).size.height / 14,
                                                                        margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                                                                        padding: const EdgeInsets.all(2),
                                                                        decoration: BoxDecoration(
                                                                          color: ConstantColor.colorPrimary,
                                                                          borderRadius: BorderRadius.circular(5),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            "Aceitar Corrida",
                                                                            style: GoogleFonts.cormorantGaramond(
                                                                              color: Colors.white,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold
                                                                            ),
                                                                          ),
                                                                        ),

                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                    },
                                                    child: Container(
                                                      height: MediaQuery.of(context).size.height * 0.05,
                                                      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                                                      padding: const EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        color: ConstantColor.colorLigth,
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [

                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.3,
                                                            child: Text(
                                                                corrida['ponto_partida'],
                                                                style: GoogleFonts.cormorantGaramond(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: ConstantColor.blackColor,
                                                                ),
                                                                overflow: TextOverflow.ellipsis
                                                            ),
                                                          ),

                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.3,
                                                            child: Text(
                                                                corrida['ponto_destino'],
                                                                style: GoogleFonts.cormorantGaramond(
                                                                  fontSize: 14,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: ConstantColor.blackColor,
                                                                ),
                                                                overflow: TextOverflow.ellipsis
                                                            ),
                                                          ),

                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.2,
                                                            child: Text(
                                                              corrida['valor_total_corrida'] + 'Kz',
                                                              style: GoogleFonts.cormorantGaramond(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.bold,
                                                                color: ConstantColor.blackColor,
                                                              ),
                                                              overflow: TextOverflow.ellipsis
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                                  :
                                              Container(
                                                child: Center(
                                                  child: Text(
                                                    'Estas Offline, altere o estado para ver\n as corridas solicitadas',
                                                    style: GoogleFonts.cormorantGaramond(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: ConstantColor.blackColor,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),

                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                    ),

                  ],
                );
                } else {
                  return const RegisterLoginScreen();
                }
              }
          );
          } else {
            return const Center(child: Text("Não conseguimos pegar a sua localização..."));
          }
        }
      ),
    );
  }

  _corrida_aceite(String foto, String nome_cliente, String telefone,
      String desejo, String valor, String partida, String destino,
      double latitude_origem_passageiro, double longitude_origem_passageiro,
      double latitude_destino_passageiro, double longitude_destino_passageiro,
      CorridaProvider corridaProvider, String id_corrida) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      //padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        //border: Border.all(width: 1, color: Colors.black38),
      ),
      child: Column(
        children: [



          //::::::::::::::::::::: CLIENT :::::::::::::::::::::: :/
          Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //------------------- PHOTO CLIENT -------------------- -/
                  Row(
                    children: [

                      CircleAvatar(
                        maxRadius: 25,
                        minRadius: 25,
                        backgroundImage: NetworkImage(
                          foto,
                        ),
                      ),

                      //------------------- SPACE -------------------- -/
                      const SizedBox(width: 5),

                      //----------------------- CLIENT NAME --------------------- -/
                      Column(
                        children: [
                          Text(
                            nome_cliente,
                            style: GoogleFonts.cormorantGaramond(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),

                          //------------------- SPACE -------------------- -/

                          Text(
                            telefone,
                            style: GoogleFonts.cormorantGaramond(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),

                  //-------------------- PRICE ---------------------- -/
                  Column(
                    children: [
                      Text(
                        valor + ' Kz',
                        style: GoogleFonts.cormorantGaramond(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Consumer<LocalizacaoProvider>(
                        builder: (context, distanceProvider, child) {
                          ConstantVariable.kilometro = distanceProvider.calculatedDistancePassageiro;
                          return Text(
                            '${distanceProvider.calculatedDistancePassageiro.toStringAsFixed(1)}Km',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ConstantColor.blackColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //:::::::::::::::::::::: SPACE :::::::::::::::::::::::: :/
          const SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on_sharp, color: Colors.green,),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          partida,
                          style: GoogleFonts.cormorantGaramond(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black
                          ),
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Icon(Icons.location_on_sharp, color: Colors.red,),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          destino,
                          style: GoogleFonts.cormorantGaramond(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black
                          ),
                            overflow: TextOverflow.ellipsis
                        ),
                      ),
                    ],
                  ),
                ],
              ),


              InkWell(
                onTap: () async {
                  await FlutterPhoneDirectCaller.callNumber(telefone);
                  //FlutterPhoneDirectCaller.callNumber(telefone_cli);
                  //FlutterPhoneDirectCaller.callNumber(telefone_cli);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle
                      ),
                      child: Icon(Icons.call),
                    ),
                    Center(
                      child: Text(
                        'Ligar',
                        style: GoogleFonts.cormorantGaramond(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: InkWell(
                  onTap: () {
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height / 14,
                    margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: ConstantColor.colorPrimary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        ConstantVariable.kilometro < 0.5 ? 'Chegou ao passageiro\nClique para iniciar a corrida' : 'A caminho do passageiro',
                        style: GoogleFonts.cormorantGaramond(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  ),
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: InkWell(
                  onTap: () {
                    setState((){
                      showDialog(context: context, builder: (BuildContextcontext) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width - 10,
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: ConstantColor.whiteColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  //--------------- TITLE ---------- -/
                                  Text(
                                    "Cancelar Corrida",
                                    style: GoogleFonts.cormorantGaramond(
                                        color: ConstantColor.colorPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  const SizedBox(height: 10),

                                  //--------------- NAME -------------- -/
                                  Text(
                                    'De certeza que quer cancelar\ a corrida?',
                                    style: GoogleFonts.cormorantGaramond(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  const SizedBox(height: 5,),

                                  Row(
                                    children: [

                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            height: MediaQuery.of(context).size.height / 14,
                                            margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: ConstantColor.colorPrimary,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Não",
                                                style: GoogleFonts.cormorantGaramond(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: InkWell(
                                          onTap: () {
                                            corridaProvider.cancelarCorrida(id_corrida, 'Cancelada');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => HomeScreen()
                                                //
                                                //ProductPage
                                              ),
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            height: MediaQuery.of(context).size.height / 14,
                                            margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: ConstantColor.whiteColor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Sim",
                                                style: GoogleFonts.cormorantGaramond(
                                                    color: ConstantColor.colorPrimary,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),

                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    });
                  },
                  child: Center(
                    child: Icon(
                      Icons.cancel,
                      size: 50,
                      color: ConstantColor.colorPrimary,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }


  //**************** ADRESS & TIME ************* */
  _adressTimeItem(IconData iconData, String description, Color color) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    Size tamanhoFonte = mediaQuery.size;
    return Container(
      child: Row(
        children: [
          Icon(
            iconData,
            size: 20,
            color: color,
          ),
          const SizedBox(
            width: 1,
          ),
          Container(
            width: 120,
            child: Text(
              description,
              style: GoogleFonts.cormorantGaramond(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  //****************** WITCHES ******************* */
  _witches(String description, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description,
          style: GoogleFonts.cormorantGaramond(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        Text(
          price,
          style: GoogleFonts.cormorantGaramond(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }


}
