import 'package:flutter/material.dart';

class Localizacao with ChangeNotifier{
  final double latitude;
  final double longitude;
  Localizacao(this.latitude, this.longitude);
}