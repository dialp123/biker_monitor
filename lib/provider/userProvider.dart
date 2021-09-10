import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Status {
  Uninitialized,
  AuthenticatedUser,
  AuthenticatedAdmin,
  Authenticating,
  Unauthenticated,
  Register,
  Registering
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("Users");
  User _user;
  Status _status = Status.Uninitialized;
  String _e;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  get status {
    return _status;
  }

  void setStatus(Status status) {
    this._status = status;
    notifyListeners();
  }

  User get user => _user;
  String get e => _e;

  Future<bool> signIn(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        firestore.collection('users').doc(value.user.uid).get().then((snap) {
          if (snap.data()['enable'] == 'false' &&
              snap.data()['admin'] == 'false') {
            signOut();
          }
        });
      });
      _status = Status.Authenticating;
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      this._e = e.toString();
      return false;
    }
  }

  // ignore: missing_return
  Future<bool> register(
      String nombre,
      String email,
      String password,
      String apellido,
      String id,
      String placa,
      String marca,
      String modelo,
      String idBiker) async {
    try {
      _status = Status.Registering;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {
        firestore.collection('users').doc(result.user.uid).set({
          'nombre': nombre,
          'correo': email,
          'apellido': apellido,
          'id': id,
          'placa': placa,
          'marca': marca,
          'modelo': modelo,
          'idBiker': idBiker,
          'admin': 'false',
          'enable': 'true'
        });
      });
      return true;
    } catch (e) {
      _status = Status.Register;
      notifyListeners();
      this._e = e.toString();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      print("Sesion cerrada");
    } else {
      firestore.collection('users').doc(firebaseUser.uid).get().then((value) {
        if (value.data()['admin'] == 'false') {
          _user = firebaseUser;
          _status = Status.AuthenticatedUser;
          print("Sesion iniciada usuario");
        } else {
          _user = firebaseUser;
          _status = Status.AuthenticatedAdmin;
          print("la cuenta es de admin");
        }
        notifyListeners();
      });
    }
    notifyListeners();
  }
}
