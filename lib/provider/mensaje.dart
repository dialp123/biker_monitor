import 'package:biker_monitor/provider/notificaciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:sms/sms.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong/latlong.dart';

// ignore: camel_case_types
class Mensaje with ChangeNotifier {
  final databaseRef = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  void addData(String data) {
    databaseRef.push().set({'name': data});
  }

  SmsMessage _msg = SmsMessage('0', '0000,0,0,0,0,0,0');
  Future<String> _idBiker;
  String _encender = '0';
  String _reporte = '0';
  // ignore: unused_field
  String _lat = '2.438286992340584';
  // ignore: unused_field
  String _long = '-76.61937957596261';
  // ignore: unused_field
  String _orientacion = '0';
  // ignore: unused_field
  String _vibracion = '0';
  MapController _mapController;

  get colorBtnAlarma {
    if (_encender == '1') {
      return Colors.blue[500];
    } else {
      return Colors.red[500];
    }
  }

  get colorBtnEncendido {
    if (_encender == '2' || _encender == '1') {
      return Colors.blue[500];
    } else {
      return Colors.red[500];
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

  get controller {
    return _mapController;
  }

  get reporte {
    return _reporte;
  }

  void setControllerMap() {
    _mapController = MapController();
    notifyListeners();
  }

  void setReporte() {
    _reporte = "1";
    notifyListeners();
  }

  void recibir(SmsMessage sms) {
    _msg = sms;
    List<String> txt = _msg.body.split(',');
    if (txt[2] != '0' && txt[2] != _reporte) {
      _reporte = txt[2];
    }
    if (txt[3] != '0' && txt[3] != _lat) {
      _lat = txt[3];
      if (_encender == '1') {
        notificacion(3, "Alerta", "Cambio en la latitud: " + _lat);
      }
    }
    if (txt[4] != '0' && txt[4] != _long) {
      _long = txt[4];
      if (_encender == '1') {
        notificacion(4, "Alerta", "Cambio en la longitud: " + _long);
      }
    }
    if (txt[5] != '0' && txt[5] != _orientacion) {
      _orientacion = txt[5];
      if (_encender == '1') {
        notificacion(5, "Alerta", "Cambio en la orientacion: " + _orientacion);
      }
    }
    if (txt[6] != '0' && txt[6] != _vibracion) {
      _vibracion = txt[6];
      if (_encender == '1') {
        notificacion(6, "Alerta", "Cambio en la vibracion: " + _vibracion);
      }
    }

    if (_reporte == '1') {
      notificacion(1, "Alerta", "Reportando robo");
      _encender = '1';
      //ejecutar accion de reportar
    }
    notifyListeners();
    _mapController.move(
        LatLng(
            double.parse(txtCoordenadas[0]), double.parse(txtCoordenadas[1])),
        16.5);
    notifyListeners();
  }

  void apagarEncenderAlarma() {
    if (_reporte == '0' && _encender != '0') {
      if (_encender == '2') {
        _encender = '1';
        notificacion(0, "Biker Monitor", "Alarma encendida");
        enviar();
      } else {
        _encender = '2';
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

  void apagarEncender() {
    if (_reporte == '0') {
      if (_encender == '0') {
        _encender = '2';
        notificacion(0, "Biker Monitor", "Sistema encendido");
        enviar();
      } else {
        _encender = '0';

        notificacion(0, "Biker Monitor", "Sistema apagado");
        enviar();
      }
    }
    notifyListeners();
  }

  Future<void> enviar() async {
    //this._msg = SmsMessage('0', '0000' + _encender + _reporte);
    SmsSender sender = new SmsSender();
    String address = /*"3233513405";*/ /*"3125036530" */ "3146453556";
    SimCardsProvider provider = new SimCardsProvider();
    List<SimCard> card = await provider.getSimCards();
    //print(card[1].slot);
    sender.sendSms(
        new SmsMessage(
            address, '0000,' + _encender + "," + _reporte + ",0,0,0,0,"),
        simCard: card[1]);
  }
}
