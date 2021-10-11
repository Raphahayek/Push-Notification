import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
//Ficará ouvindo as mensagens que chegarão a qualquer momento e notificará.
//Induz abrir o aplicativo mesmo ele fechado, ficará atento as mensagens, ouvindo-as.

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //Verificar se está tudo correto na inicialização
  await Firebase.initializeApp(); //Inicialização
  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler); //Antes de executar a inicialização ele já estará ouvindo em background.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? message;

  _registrerOnFirebase() {
    _fcm.subscribeToTopic('all');
    _fcm.getToken().then((token) => print(token));
  } //Serviço do firebase estará subscrito em todos os tópicos, pega o token e printar na tela.
  //Aplicação rodada, firebase inicializado e tem um token pra aparecer a mensagem.

  @override
  void initState() {
    _registrerOnFirebase();
    getMessage();
    super.initState();
  } //Inicializar

  void getMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      print('Message receive $remoteMessage');
      setState(() => message = remoteMessage.notification!.body);
    }); //Ouvir a mensagem, recebe e depois da setstate para a variável mensagem(null)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      setState(() => message = remoteMessage.notification!.body);
      //recebe o mesmo, mas diz para abrir o app quando clicar na notificação.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$message',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
