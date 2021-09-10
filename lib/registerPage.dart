import 'package:biker_monitor/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 10.0);
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController nombreController;
  TextEditingController apellidoController;
  TextEditingController idController;
  //vehiculo
  TextEditingController placaController;
  TextEditingController marcaController;
  TextEditingController modeloController;
  //dispositivo
  TextEditingController idBikerController;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    nombreController = TextEditingController(text: "");
    apellidoController = TextEditingController(text: "");
    idController = TextEditingController(text: "");
    placaController = TextEditingController(text: "");
    modeloController = TextEditingController(text: "");
    marcaController = TextEditingController(text: "");
    idBikerController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
        key: _key,
        appBar: AppBar(title: Text("Nuevo usuario")),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(1.0),
                child: Text("Datos usuario:",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    labelText: "Nombres",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese un nombre';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: apellidoController,
                  decoration: InputDecoration(
                    labelText: "Apellidos",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese un apellido';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: "Identificación",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese un numero de identificación';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese un correo electrónico';
                    } else if (!value.contains('@')) {
                      return 'ingrese un correo electrónico valido';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese una contraseña';
                    } else if (value.length < 6) {
                      return 'Ingrese una contraseña mayor a 6 caracteres';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(1.0),
                child: Text("Datos vehículo:",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: placaController,
                  decoration: InputDecoration(
                    labelText: "Placa",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese un numero de placa';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: marcaController,
                  decoration: InputDecoration(
                    labelText: "Marca",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese marca';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: modeloController,
                  decoration: InputDecoration(
                    labelText: "Modelo",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese modelo';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(1.0),
                child: Text("Datos dispositivo biker monitor:",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: idBikerController,
                  decoration: InputDecoration(
                    labelText: "Numero serie",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese un numero de serie';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.black54,
                        child: MaterialButton(
                          onPressed: () {
                            user.setStatus(Status.Unauthenticated);
                          },
                          child: Text(
                            "Volver",
                            style: style.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    user.status == Status.Registering
                        ? Center(child: CircularProgressIndicator())
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.red,
                              child: MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    if (!await user.register(
                                        nombreController.text,
                                        emailController.text,
                                        passwordController.text,
                                        apellidoController.text,
                                        idController.text,
                                        placaController.text,
                                        marcaController.text,
                                        modeloController.text,
                                        idBikerController.text))
                                      // ignore: deprecated_member_use
                                      _key.currentState.showSnackBar(SnackBar(
                                        content: Text(user.e),
                                      ));
                                  }
                                },
                                child: Text(
                                  "Registrar",
                                  style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ]))));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nombreController.dispose();
    apellidoController.dispose();
    idController.dispose();
    placaController.dispose();
    modeloController.dispose();
    marcaController.dispose();
    idBikerController.dispose();
    super.dispose();
  }
}
