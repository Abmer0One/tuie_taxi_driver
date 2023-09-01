import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tuie_driver_taxi/provider/alerta_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuie_driver_taxi/provider/alerta_provider.dart';

class AuthProvider with ChangeNotifier {

  User? _user;
  User? get user => _user;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  AuthProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
      _user = firebaseUser;
      notifyListeners();
    });
  }

  String? _motoristaEmail;
  String? get motoristaEmail => _motoristaEmail;
  String? _motoristaTelefone;
  String? get motoristaTelefone => _motoristaTelefone;

  Future<void> checkMotorista(String phoneNumber) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('motorista')
          .where('telefone_motorista', isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _motoristaEmail = snapshot.docs[0]['email_motorista'];
        _motoristaTelefone = snapshot.docs[0]['telefone_motorista'];
      } else {
        _motoristaEmail = null;
        _motoristaTelefone = null;
      }

      notifyListeners();
    } catch (e) {
      print("Erro ao verificar passageiro: $e");
    }
  }

  Future<void> signUp(String nome_motorista, String sobrenome_motorista, String telefone_motorista,
      String password_motorista, String id_estado, String email_motorista,
      String bi_motorista, String passaport_motorista) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email_motorista,
        password: password_motorista,
      );


      String userId = userCredential.user!.uid;
      // Obter a função do usuário autenticado...

     // String imageUrl = '';

     /* if (image != null) {
        imageUrl = await uploadImage(image, userId);
      }*/

      await FirebaseFirestore.instance.collection('motorista').doc(userId).set({
        'nome_motorista': nome_motorista,
        'sobrenome_motorista': sobrenome_motorista,
        'telefone_motorista': telefone_motorista,
        'password_motorista': password_motorista,
        'id_estado': id_estado,
        'email_motorista': email_motorista,
        'bi_motorista': bi_motorista,
        'passaport_motorista': passaport_motorista,
      });

      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      // Lidar com erros de registro...
      print('erro5'+e.toString());
    }
  }

  Future<void> signIn(String email, String password, AlertDialogProvider alertDialogProvider, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      if (_user != null) {
        // Autenticação bem-sucedida...
        return alertDialogProvider.sucessLoginAlert(context, 'Sucesso', 'Login efectuado com sucesso.');
      } else {
        // Autenticação falhou...
        return alertDialogProvider.errorAlert(context, 'Erro', 'Login falhou.');
      }
      notifyListeners();
    } catch (e) {
      // Lidar com erros de login...
      return alertDialogProvider.errorAlert(context, 'Erro', 'Credencias erradas.');
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      // Lidar com erros de logout...
    }
  }

  Future<String> uploadImage(File image, String userId) async {
    // Implemente o código de upload de imagem para o armazenamento do Firebase...
    try {
      final firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('imagem_usuario').child(userId + '.jpg');

      final firebase_storage.UploadTask uploadTask = storageReference.putFile(image);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      return '';
    }
  }

  Map<String, dynamic>? _dados_do_motorista;
  Map<String, dynamic>? get dados_do_motorista => _dados_do_motorista;

  Future<void> motoristaPorEmail(String email_passageiro) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('motorista')
          .where('email_motorista', isEqualTo: email_passageiro)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _dados_do_motorista = snapshot.docs.first.data();
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching passenger data: $error');
    }
  }

  Stream<QuerySnapshot> getMotoristaStream(String telefone_passageiro) {
    return _firestore.collection('motorista').where('telefone_motorista', isEqualTo: telefone_passageiro).snapshots();
  }

  Stream<QuerySnapshot> getMotoristaEmailStream(String email_passageiro) {
    return _firestore.collection('motorista').where('email_motorista', isEqualTo: email_passageiro).snapshots();
  }

  Stream<QuerySnapshot> getUsuarioStream(String email_usuario) {
    return _firestore.collection('Usuario').where('email', isEqualTo: email_usuario).snapshots();
  }

  Future<void> editarUsuario(String usuarioId, File foto_usuario,
      String nome_usuario, String sobrenome_usuario,
      String passaport_usuario, String bi_usuario, String telefone_usuario) async {
    try {

      // Faz o upload da nova foto para o Firebase Storage...
      if (foto_usuario != null) {
        final refUsuario = _storage.ref().child('imagem_motorista/${usuarioId}.jpg');
        await refUsuario.putFile(foto_usuario);

        final fotoUrlUsuario = await refUsuario.getDownloadURL();

        // Atualiza a URL da foto no Firestore...
        await _firestore.collection('motorista').doc(usuarioId).update({
          'foto_motorista': fotoUrlUsuario,
        });

        // Atualiza o nome e telefone no Firestore...
        await _firestore.collection('motorista').doc(usuarioId).update({
          'foto_motorista': fotoUrlUsuario,
          'bi_motorista' : bi_usuario,
          'nome_motorista' : nome_usuario,
          'passaport_motorista' : passaport_usuario,
          'sobrenome_motorista' : sobrenome_usuario,
          'telefone_motorista' : telefone_usuario,
        });
      }
    } catch (error) {

    }
  }

  Future<void> editarPacoteEstadoUsuario(String usuarioId, bool estado, int tipo_de_pacote) async {
    try {
      // Atualiza o estado e pacote no Firestore...
      await _firestore.collection('Usuario').doc(usuarioId).update({
        'estado': estado,
        'tipo_de_pacote': tipo_de_pacote,
      });

    } catch (error) {

    }
  }

  /*Future<String?> signInWithGoogle(String password, File? image) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Autenticação bem-sucedida, retorne o ID do usuário...
        //signUp(user.email!, password, user.displayName!, image);
        return user.uid;
      } else {
        // Autenticação falhou
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
    await auth.signOut();
  }*/

}







