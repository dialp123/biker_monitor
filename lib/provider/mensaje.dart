import 'package:biker_monitor/provider/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

// ignore: camel_case_types
class Mensaje with ChangeNotifier {
  final databaseRef = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  void addData(String data) {
    databaseRef.push().set({'name': data});
  }

  SmsMessage _msg = SmsMessage('0', '0000,0,0,0,0,0,0');
  String _encender = '0';
  String _reporte = '0';
  // ignore: unused_field
  String _lat = '0';
  // ignore: unused_field
  String _long = '0';
  // ignore: unused_field
  String _orientacion = '0';
  // ignore: unused_field
  String _vibracion = '0';

  get colorBtnEncendido {
    if (_encender == '0') {
      return Colors.red[500];
    } else if (_encender == '1') {
      return Colors.blue[500];
    }
  }

  get txtBtnReporte {
    if (_reporte == '1') {
      return 'Reportado';
    } else if (_reporte == '0') {
      return 'Reportar';
    }
  }

  get txtOrientacion {
    return _orientacion;
  }

  get txtVibracion {
    return _vibracion;
  }

  get txtCoordenadas {
    return (_lat + ',' + _long).split(',');
  }

  void recibir(SmsMessage sms) {
    _msg = sms;
    List<String> txt = _msg.body.split(',');
    _reporte = txt[2];
    _lat = txt[3];
    _long = txt[4];
    _orientacion = txt[5];
    _vibracion = txt[6];

    if (_reporte == '1') {
      notificacion(1, "Biker Monitor", "Reportando robo");
      _encender = '1';
      //ejecutar accion de reportar
    }
    notifyListeners();
  }

  void apagarEncender() {
    if (_reporte == '0') {
      if (_encender == '0') {
        _encender = '1';
        notificacion(0, "Biker Monitor", "Alarma encendida");
        enviar();
      } else {
        _encender = '0';
        notificacion(0, "Biker Monitor", "Alarma apagada");
        _lat = '0';
        _long = '0';
        _orientacion = '0';
        _vibracion = '0';
        enviar();
      }
    }
    notifyListeners();
  }

  void enviar() {
    //this._msg = SmsMessage('0', '0000' + _encender + _reporte);
    //enviar mensaje
  }
}
