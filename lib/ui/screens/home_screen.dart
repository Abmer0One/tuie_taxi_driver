import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuie_driver_taxi/component/drawer_component.dart';
import 'package:tuie_driver_taxi/model/localizacao_model.dart';
import 'package:tuie_driver_taxi/provider/localizacao_provider.dart';
import 'package:tuie_driver_taxi/services/localizacao_service.dart';
import 'package:tuie_driver_taxi/ui/widgets/home_widget.dart';
import 'package:flutter/foundation.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var localizacaoProvider = Provider.of<LocalizacaoProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        body: StreamProvider<Localizacao>(
            initialData: localizacaoProvider.userLocation,
            create: (context) => LocationServices().locationStream,
            child: HomeWidget( scaffoldKey: _scaffoldKey)),
        drawer: DrawerComponent(),
      ),
    );
  }
}


