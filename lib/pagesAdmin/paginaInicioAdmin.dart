import 'package:biker_monitor/provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'paginaMenuAdmin.dart';
import 'paginaUsuariosInfo.dart';
import 'paginaForoAdmin.dart';

class InicioAdmin extends StatefulWidget {
  @override
  _InicioAdmin createState() => _InicioAdmin();
}

class _InicioAdmin extends State<InicioAdmin> {
  int _paginaActual = 2;
  List<Widget> _paginas = [
    PaginaForoAdmin(),
    PaginaInicioAdmin(),
    PaginaUsuariosInfo(),
    PaginaMenuAdmin(),
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
            icon: Icon(Icons.two_wheeler, color: Colors.black),
            label: "Inicio",
            // ignore: deprecated_member_use
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt, color: Colors.black),
              label: "Informacion"),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu, color: Colors.black), label: "Menu"),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class PaginaInicioAdmin extends StatelessWidget {
  const PaginaInicioAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    Color colorButton;
    return StreamBuilder(
        stream: user.firestore.collection('reportes').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          List<DocumentSnapshot> docs = snapshot.data.docs;

          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data = docs[index].data();
                if (data['reporte'] == 'false') {
                  colorButton = Colors.red[100];
                } else {
                  colorButton = Colors.green[100];
                }
                return new Card(
                  child: Container(
                    color: colorButton,
                    height: 70,
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        _onPressedBtn(context, docs[index].id, user);
                      },
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Text("   Placa:             ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              new Text(data['placa'].toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Text("   Usuario:         ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              new Text(data['usuario'].toString())
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  void _onPressedBtn(BuildContext context, String id, UserRepository user) {
    Color colorButton;
    String textButton;
    showDialog(
      context: context,
      builder: (_) => new StreamBuilder(
          stream: user.firestore.collection('reportes').doc(id).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            Map<String, dynamic> data = snapshot.data.data();
            if (data['reporte'] == 'false') {
              colorButton = Colors.red;
              textButton = "Reportar";
            } else {
              colorButton = Colors.green;
              textButton = "Reportado";
            }
            return SimpleDialog(
              title: Text("Detalle hurto"),
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
                  title: Text("Placa:" + data['placa']),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: colorButton,
                    child: MaterialButton(
                      onPressed: () async {
                        if (data['reporte'] == "false") {
                          print("Reporte: " + data['reporte']);
                          user.firestore
                              .collection('reportes')
                              .doc(id)
                              .update({'reporte': 'true'});
                        }
                      },
                      child: Text(
                        textButton,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.grey,
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cerrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
