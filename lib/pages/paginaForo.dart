import 'package:biker_monitor/provider/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaginaForo extends StatefulWidget {
  @override
  _PaginaForo createState() => _PaginaForo();
}

class _PaginaForo extends State<PaginaForo> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController textController;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  // ignore: override_on_non_overriding_member
  void initState() {
    super.initState();
    textController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 450,
            color: Colors.red,
            child: StreamBuilder(
                stream: user.firestore.collection('foro').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  List<DocumentSnapshot> docs = snapshot.data.docs;

                  return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> data = docs[index].data();
                        return new Card(
                          child: Container(
                            color: Colors.grey[200],
                            height: 50,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {},
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      new Text(data['usuario'] + ": ",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      new Text(
                                        data['texto'].toString(),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
          Container(
            height: 50,
            color: Colors.yellow,
            child: TextFormField(
              controller: textController,
              validator: (value) => (value.isEmpty) ? "Ingrese texto" : null,
              style: style,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Foro",
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (textController.text != "") {
            user.firestore.collection('foro').add(
                {'texto': textController.text, 'usuario': user.user.email});
          }
        },
        child: Icon(Icons.text_fields),
      ),
    );
  }

  @override
  // ignore: must_call_super
  void dispose() {
    textController.dispose();
  }
}
