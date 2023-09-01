import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CorridaProvider with ChangeNotifier {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  DocumentSnapshot? _lastRun;
  DocumentSnapshot? get lastRun => _lastRun;

  Stream<QuerySnapshot> getCorridasStream(String id_passageiro) {
    return _firestore.collection('corridas').where('id_motorista', isEqualTo: id_passageiro).snapshots();
  }

  Future<void> fetchLastRun() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('corridas')
          .orderBy('data_corrida', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _lastRun = snapshot.docs.first;
      }

      notifyListeners();
    } catch (error) {
      print('Erro ao buscar última corrida: $error');
    }
  }

  Future<String> uploadImage_funcionario(File image, String userId) async {
    // Implemente o código de upload de imagem para o armazenamento do Firebase...
    try {
      final firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('imagem_funcionario').child(userId + '.jpg');

      final firebase_storage.UploadTask uploadTask = storageReference.putFile(image);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return '';
    }
  }

  Future<List<DocumentSnapshot>> getCorridas(String telefone_motorista) async {
    try {
      final snapshot = await _firestore
          .collection('corridas')
          .where('telefone_motorista', isEqualTo: telefone_motorista)
          .get();
      return snapshot.docs;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<DocumentSnapshot>> getTodasCorridas() async {
    try {
      final snapshot = await _firestore.collection('corridas')
          .where('estado_corrida', isEqualTo: 'Solicitada')
          .get();
      return snapshot.docs;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> editarEstadoCorrida(String corridaId, String estado_corrida,
      String nome_motorista, String telefone_motorista, double latitude_motorista,
      double longitude_motorista, String ponto_motorista, String foto_motorista) async {
    try {
      // Atualiza o nome e telefone no Firestore...
      await _firestore.collection('corridas').doc(corridaId).update({
        'estado_corrida': estado_corrida,
        'telefone_motorista': telefone_motorista,
        'latitude_motorista': latitude_motorista,
        'nome_motorista': nome_motorista,
        'longitude_motorista': longitude_motorista,
        'ponto_motorista': ponto_motorista,
        'foto_motorista': foto_motorista,
      });
    } catch (error) {}
  }

  void actualizarLocalizacaoMotorista(String telefone_motorista, double latitude, double longitude) async {
    final CollectionReference driversCollection = _firestore.collection('motorista');
    StreamSubscription<DocumentSnapshot> subscription;
    subscription = driversCollection.doc(telefone_motorista).snapshots().listen((event) async {
      await driversCollection.doc(telefone_motorista).update({
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
      });
    });
    // Encerre a assinatura quando não for mais necessário (por exemplo, quando a tela for desmontada).
    // subscription.cancel();
  }

  Future<void> cancelarCorrida(String corridaId, String estado_corrida) async {
    try {
      // Atualiza o nome e telefone no Firestore
      await _firestore.collection('corridas').doc(corridaId).update({
        'estado_corrida': estado_corrida,
      });
    } catch (error) {
    }
  }

}

