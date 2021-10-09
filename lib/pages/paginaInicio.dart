import 'package:biker_monitor/provider/mensaje.dart';
import 'package:biker_monitor/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import 'paginaForo.dart';
import 'paginaInfo.dart';
import 'paginaMenu.dart';
import 'paginaRobos.dart';

class InicioUser extends StatefulWidget {
  @override
  _InicioUser createState() => _InicioUser();
}

class _InicioUser extends State<InicioUser> {
  int _paginaActual = 2;

  List<Widget> _paginas = [
    PaginaForo(),
    paginaRobos(),
    paginaInicio(),
    paginaInfo(),
    paginaMenu(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Biker Monitor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              user.signOut();
            },
          )
        ],
      ),
      body: _paginas[_paginaActual],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            _paginaActual = index;
          });
        },
        currentIndex: _paginaActual,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.message, color: Colors.black), label: "Foro"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on, color: Colors.black),
              label: "Robos area"),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: "Inicio",
            // ignore: deprecated_member_use
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: Colors.black),
              label: "Informacion"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu, color: Colors.black), label: "Menu"),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class paginaInicio extends StatefulWidget {
  @override
  _paginaInicio createState() => _paginaInicio();
}

// ignore: camel_case_types
class _paginaInicio extends State<paginaInicio> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mensaje = Provider.of<Mensaje>(context);
    final user = Provider.of<UserRepository>(context);
    mensaje.setControllerMap();
    return SizedBox(
      width: double.infinity,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            child: Container(
              color: Colors.orange,
              height: 230,
              width: double.infinity, //obtiene el ancho de la pantalla
              margin: EdgeInsets.all(10),
              child: FlutterMap(
                mapController: mensaje.controller,
                options: MapOptions(
                  center: LatLng(double.parse(mensaje.txtCoordenadas[0]),
                      double.parse(mensaje.txtCoordenadas[1])),
                  zoom: 16.5,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(double.parse(mensaje.txtCoordenadas[0]),
                            double.parse(mensaje.txtCoordenadas[1])),
                        builder: (ctx) => Container(
                          child: Icon(Icons.location_on,
                              size: 40, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              color: Colors.grey[200],
              height: 60,
              margin: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "   Coordenadas GPS:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '    Lat:      ' + mensaje.txtCoordenadas[0],
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '    Long:   ' + mensaje.txtCoordenadas[1],
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              color: Colors.grey[200],
              height: 30,
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text("   Orientacion:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  new Text(mensaje.txtOrientacion + ' °/s    '),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              color: Colors.grey[200],
              height: 30,
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Text("   Vibración:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  new Text(mensaje.txtVibracion + " %    "),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: mensaje.colorBtnEncendido,
                  child: IconButton(
                    icon: const Icon(Icons.power_settings_new),
                    onPressed: () {
                      mensaje.apagarEncender();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: mensaje.colorBtnAlarma,
                  child: IconButton(
                    icon: const Icon(Icons.motorcycle),
                    onPressed: () {
                      mensaje.apagarEncenderAlarma();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.yellow[500],
                  child: MaterialButton(
                    onPressed: () {
                      if (mensaje.reporte == "0") {
                        _onPressedBtn(context, mensaje, user);
                      }
                    },
                    child: Text(
                      mensaje.txtBtnReporte,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onPressedBtn(
      BuildContext context, Mensaje mensaje, UserRepository user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Container(
            child: Text(
              "Advertencia",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          children: <Widget>[
            ListTile(
              title: Text(
                "¿Desea reportar robo del vehiculo?",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // ignore: deprecated_member_use
                OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cerrar"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
                // ignore: deprecated_member_use
                OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                      mensaje.setReporte();
                      user.reportar("dd-mm-aaaa", "hh:mm",
                          mensaje.txtCoordenadas[0], mensaje.txtCoordenadas[1]);
                    },
                    child: Text("Aceptar"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7))),
              ],
            ),
          ],
        );
      },
    );
  }
}
