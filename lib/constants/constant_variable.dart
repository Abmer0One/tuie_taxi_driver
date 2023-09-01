
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConstantVariable {

  //***************** MAPA ******************** */
  static String chaveAPI = 'AIzaSyDnS-LAt0PZd0KgnpBrE24LMjhmMCk4tWE';
  static bool rota_definida = false;
  static bool mapa_precionado = false;
  static double distancia_por_km = 0.0;
  static double latitude_origem = 0;
  static double longitude_origem = 0;
  static double latitude_destino = 0;
  static double longitude_destino = 0;
  static double kilometro = 0;
  static Set<Marker> marcadores = Set();
  static CameraPosition initialCameraPosition = CameraPosition(zoom: 18, target: LatLng(0.0, 0.0));
  static CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(LatLngBounds(southwest: LatLng(0.0, 0.0), northeast: LatLng(0.0, 0.0)), 100);

  //***************** ESTADO PAINEL ******************** */
  static bool corrida_solicitada = false;
  static bool corrida_aceite_pelo_motorista = false;

  //***************** LUGARES ******************** */
  static String onde_estou = '';
  static String onde_vou = '';
  static String onde_passageiro_esta = '';
  static String onde_passageiro_vai = '';

 //***************** TIPO DE CORRIDA ******************** */
  static bool corrida_economica = false;
  static String valor_desejo_corrida = '';
  static String id_corrida = '';
  static bool corrida_confortavel = false;
  static int pacoteSelecionado = -1;
  static int selectedIndex = 2;
  static String valor_da_corrida = '';

  //***************** TIPO DE CORRIDA ******************** */
  static String id_passageiro = '';

  //***************** DADOS DO PASSAGEIRO ******************** */
  static String foto_passageiro = '';
  static String nome_passageiro = '';
  static String sobrenome_passageiro = '';
  static String telefone_passageiro = '';
  static String email_passageiro = '';

  //***************** DADOS DO MOTORISTA ******************** */
  static String id_motorista = '';
  static String foto_motorista = '';
  static String nome_motorista = '';
  static String sobrenome_motorista = '';
  static String telefone_motorista = '';
  static String email_motorista = '';
}