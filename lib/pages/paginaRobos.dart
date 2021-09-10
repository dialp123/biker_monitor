import 'package:biker_monitor/provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class paginaRobos extends StatelessWidget {
  const paginaRobos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return StreamBuilder(
        stream: user.firestore.collection('reportes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          List<DocumentSnapshot> docs = snapshot.data.docs;

          return FlutterMap(
            options: MapOptions(
              center: LatLng(1.800679, -77.165803),
              zoom: 18.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              _marcadores(context, docs),
            ],
          );
        });
  }

  MarkerLayerOptions _marcadores(
      BuildContext context, List<DocumentSnapshot> docs) {
    return MarkerLayerOptions(markers: _buildMarkersOnMap(context, docs));
  }

  List<Marker> _buildMarkersOnMap(
      BuildContext context, List<DocumentSnapshot> docs) {
    List<Marker> markers = List<Marker>();

    for (var item in docs) {
      Map<String, dynamic> data = item.data();

      Marker marker = Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(data['lat'], data['long']),
        builder: (ctx) => Container(
          child: IconButton(
            icon: Icon(
              Icons.warning,
              color: Colors.red,
              size: 30,
            ),
            onPressed: () {
              _onPressedBtn(context, data);
            },
          ),
        ),
      );
      markers.add(marker);
    }
    Marker markerLocation = Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(1.801199, -77.166623),
      builder: (ctx) => Container(
        child: IconButton(
          icon: Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 30,
          ),
          onPressed: () {},
        ),
      ),
    );
    markers.add(markerLocation);
    return markers;
  }

  void _onPressedBtn(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Detalles de hurto"),
          children: <Widget>[
            ListTile(
              title: Text("Coordenadas:   "),
            ),
            ListTile(
              title: Text("Lat: " +
                  data['lat'].toString() +
                  " , Long: " +
                  data['long'].toString()),
            ),
            ListTile(
              title: Text("placa: " + data['placa']),
            ),
            ListTile(
              title: Text("Modelo:  " + data['modelo']),
            ),
            ListTile(
              title: Text("Usuario: " + data['usuario']),
            ),
            ListTile(
              title: Text("Fecha:   " + data['fecha']),
            ),
            ListTile(
              title: Text("Hora:    " + data['hora']),
            ),
            ListTile(
              title: Text("Cerrar"),
              leading: Icon(Icons.close),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
