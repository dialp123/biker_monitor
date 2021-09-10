import 'package:biker_monitor/provider/mensaje.dart';
import 'package:biker_monitor/provider/notificaciones.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pagesAdmin/paginaInicioAdmin.dart';
import 'provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms/sms.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'pages/paginaInicio.dart';
import 'registerPage.dart';
import 'loginPage.dart';

final FlutterLocalNotificationsPlugin flip =
    new FlutterLocalNotificationsPlugin();

void main() async {
  //notificaciones
  WidgetsFlutterBinding.ensureInitialized();
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var settings = new InitializationSettings(android: android);
  await flip.initialize(settings, onSelectNotification: onSelectNotification);

  //firebase
  await Firebase.initializeApp();
  runApp(MyAppState());
}

class MyAppState extends StatefulWidget {
  //MyAppState({Key? key}) : super(key: key);

  @override
  _MyAppStateState createState() => _MyAppStateState();
}

class _MyAppStateState extends State<MyAppState> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: missing_required_param
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserRepository.instance()),
        ChangeNotifierProvider(create: (context) => Mensaje())
      ],
      child: Consumer(
        // ignore: missing_return
        builder: (context, UserRepository user, _) {
          getIncomingMessage(context);
          switch (user.status) {
            case Status.Register:
            case Status.Registering:
              return RegisterPage();
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.AuthenticatedUser:
              return InicioUser();
            case Status.AuthenticatedAdmin:
              return InicioAdmin();
          }
        },
      ),
    );
  }
}

getIncomingMessage(BuildContext contxt) async {
  // Create SMS Receiver Listener
  final mensaje = Provider.of<Mensaje>(contxt);
  SmsReceiver receiver = new SmsReceiver();
  receiver.onSmsReceived.listen((SmsMessage msg) => {
        //print(msg.address),
        //print(msg.date),
        if (msg.body.split(',')[0] == '0000')
          {
            mensaje.recibir(msg),
            print(msg.body.split(',')),
          }
        //print(msg.isRead),
        //print(msg.sender),
        //print(msg.threadId),
        //print(msg.state)
      });
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text("Cargando"),
      ),
    );
  }
}
