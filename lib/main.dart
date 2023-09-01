import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tuie_driver_taxi/model/localizacao_model.dart';
import 'package:tuie_driver_taxi/provider/alerta_provider.dart';
import 'package:tuie_driver_taxi/provider/corrida_provider.dart';
import 'package:tuie_driver_taxi/provider/localizacao_provider.dart';
import 'package:tuie_driver_taxi/provider/provider_autenticacao.dart';
import 'package:tuie_driver_taxi/provider/provider_usuario.dart';
import 'package:tuie_driver_taxi/provider/tipo_de_servico_provider.dart';
import 'package:tuie_driver_taxi/ui/screens/initial_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProviderUsuario(),
        ),
        ChangeNotifierProvider(
          create: (_) => AlertDialogProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalizacaoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CorridaProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TipoDeServicoProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Localizacao(0,0),
        ),
      ],
      child: MaterialApp(
        title: 'Tuie Driver Taxi Demo',
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const InitialScreen(),
      ),
    );
  }
}


