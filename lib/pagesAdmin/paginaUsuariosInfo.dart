import 'package:biker_monitor/provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class PaginaUsuariosInfo extends StatelessWidget {
  const PaginaUsuariosInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return StreamBuilder(
        stream: user.firestore
            .collection('users')
            .where('admin', isEqualTo: 'false')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          List<DocumentSnapshot> docs = snapshot.data.docs;

          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data = docs[index].data();
                return new Card(
                  child: Container(
                    color: Colors.grey[200],
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
                              new Text("   Nombre:        ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              new Text(data['nombre'].toString()),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              new Text("   Correo:         ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  )),
                              new Text(data['correo'].toString())
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
          stream: user.firestore.collection('users').doc(id).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            Map<String, dynamic> data = snapshot.data.data();
            if (data['enable'] == 'false') {
              colorButton = Colors.red;
              textButton = "Activar";
            } else {
              colorButton = Colors.green;
              textButton = "Desactivar";
            }
            return SimpleDialog(
              title: Text("Información usuario"),
              children: <Widget>[
                ListTile(
                  title: Text("Correo " + data['correo']),
                ),
                ListTile(
                  title: Text("Nombres: " + data['nombre']),
                ),
                ListTile(
                  title: Text("Apellidos: " + data['apellido']),
                ),
                ListTile(
                  title: Text("identificación: " + data['id']),
                ),
                ListTile(
                  title: Text("Vehículo marca: " + data['marca']),
                ),
                ListTile(
                  title: Text("Vehículo modelo: " + data['modelo']),
                ),
                ListTile(
                  title: Text("Vehículo placa: " + data['placa']),
                ),
                ListTile(
                  title: Text("dispositivo biker: " + data['idBiker']),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: colorButton,
                    child: MaterialButton(
                      onPressed: () async {
                        if (data['enable'] == 'false') {
                          user.firestore
                              .collection('users')
                              .doc(id)
                              .update({'enable': 'true'});
                        } else {
                          user.firestore
                              .collection('users')
                              .doc(id)
                              .update({'enable': 'false'});
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
