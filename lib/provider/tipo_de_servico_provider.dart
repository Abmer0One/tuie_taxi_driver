import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TipoDeServicoProvider extends ChangeNotifier {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot> getTipoDeServicosStream() {
    return _firestore.collection('tipo_de_servico').snapshots();
  }

  int calculateTotal(int kilometro, int kilometroInicial, int precoInicial, int precoAdicional) {
    int total;

    if (kilometro <= kilometroInicial) {
      total = precoInicial;
    } else {
      int valor = kilometro - kilometroInicial;
      int subTotal = 0;

      for (int i = 0; i <= valor; i++) {
        subTotal = i * precoAdicional;
      }

      total = precoInicial + subTotal;
    }

    return total;
  }
}