import 'dart:developer';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/* import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart'; */

final Dados = FirebaseFirestore.instance.collection("Usuarios");

String? dados = '';
Future dadoBanco() async {
  await Dados.doc('012').get().then((snapshot) async {
    dados = snapshot.data()!['Nome'];
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AppWight());
}

class AppWight extends StatelessWidget {
  const AppWight({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.grey,
            brightness: AppController.instance.isLight
                ? Brightness.light
                : Brightness.dark,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/edit': (context) => HomePage(),
            '/form': (context) => MyForm(),
            '/segundo': (context) => SinglePage(),
          },
        );
      },
    ));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String nome = '';
  String idade = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page"),
        leading: Icon(Icons.home),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/edit');
              },
              child: const Text('Editar'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/form');
            },
            child: const Text('Dados'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/segundo');
            },
            child: const Text('Desafio 2'),
          )
        ],
      ),
      //body
      body: Container(
        // padding: const EdgeInsets.all(16.0),
        //form
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(0.1),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 100,
                height: 100,
                child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/152/152532.png'),
              ),
              Container(
                height: 20,
              ),
              TextField(
                onChanged: (text) {
                  nome = text;
                },
                decoration: InputDecoration(
                  labelText: 'Seu nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  icon: new Icon(Icons.login, color: Color(0xff224597)),
                  fillColor: Colors.black,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              Material(
                elevation: 18,
                shadowColor: Colors.white,
                child: TextField(
                  onChanged: (text) {
                    idade = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Idade',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    icon: new Icon(Icons.lock, color: Color(0xff224597)),
                    fillColor: Colors.black,
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Usuarios")
                      .doc("012")
                      .set({"Nome": nome, "Idade": idade});
                  dadoBanco();
                  print(dados.toString());

                  //db.collection("Usuarios").doc("012").delete();
                },
                child: Text('Enter'),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class MyForm extends StatelessWidget {
  const MyForm({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Register"),
        leading: Icon(Icons.route),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/edit');
              },
              child: const Text('Editar'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text('Cadastrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/segundo');
            },
            child: const Text('Desafio 2'),
          )
        ],
      ),
      //body
      body: Container(
        // padding: const EdgeInsets.all(16.0),
        //form
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Dados do Usuário"),
              Container(
                height: 20,
              ),
              Text('nome:  ${dados.toString()}'),
              SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Material(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/');
                            FirebaseFirestore.instance
                                .collection("Usuarios")
                                .doc("012")
                                .delete();

                            dados = '';
                          },
                          child: const Text('Deletar Perfil'),
                        ),
                      ),
                    ),
                    Material(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/');
                        },
                        child: const Text('Editar perfil'),
                      ),
                    ),
                  ])
            ]),
          ),
        ),
      ),
    );
  }
}

class AppController extends ChangeNotifier {
  static AppController instance = AppController();
  bool isLight = false;

  changeTheme() {
    isLight = !isLight;
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String idade = '';
  String nome = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.create),
        title: Text(
          'Editar',
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/edit');
              },
              child: const Text('Editar'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/form');
            },
            child: const Text('Dados'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/segundo');
            },
            child: const Text('Desafio 2'),
          ),
          CustomSwitch(),
        ],
      ),
      body: Container(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(0.1),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 100,
                height: 100,
                child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/32/32355.png'),
              ),
              Container(
                height: 20,
              ),
              TextField(
                onChanged: (text) {
                  nome = text;
                },
                decoration: InputDecoration(
                  labelText: 'Seu nome',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ),
                  ),
                  icon: new Icon(Icons.login, color: Color(0xff224597)),
                  fillColor: Colors.black,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              Material(
                elevation: 18,
                shadowColor: Colors.white,
                child: TextField(
                  onChanged: (text) {
                    idade = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Idade',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    icon: new Icon(Icons.lock, color: Color(0xff224597)),
                    fillColor: Colors.black,
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Usuarios")
                      .doc("012")
                      .set({"Nome": nome, "Idade": idade});
                  dadoBanco();
                  print(dados.toString());

                  //db.collection("Usuarios").doc("012").delete();
                },
                child: Text('Atualizar'),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (Switch(
        value: AppController.instance.isLight,
        onChanged: (value) {
          AppController.instance.changeTheme();
        }));
  }
}

class SinglePage extends StatefulWidget {
  const SinglePage({Key? key}) : super(key: key);

  @override
  State<SinglePage> createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  String texto = '';
  int valor = 0;
  int secondval = 0;
  String result = '';

  List<String> aux = [
    "Zero",
    "Um",
    "Dois",
    "Tres",
    "Quatro",
    "Cinco",
    "Seis",
    "Sete",
    "Oito",
    "Nove"
  ];
  List<String> cont = [
    "Dez",
    "Onze",
    "Doze",
    "Treze",
    "Quatorze",
    "Quinze",
    "Dezeseis",
    "Dezesete",
    "Dezoito",
    "Dezenove"
  ];
  List<String> number = [
    "Vinte",
    "Trinta",
    "Quarenta",
    "Cinquenta",
    "Sessenta",
    "Setenta",
    "Oitenta",
    "Noventa",
    "Cem",
    "Nove"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page"),
        leading: Icon(Icons.route),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/edit');
              },
              child: const Text('Editar'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/form');
            },
            child: const Text('Dados'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text('Login'),
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 20,
            ),
            TextField(
              onChanged: (text) {
                valor = int.parse(text);
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Informe um valor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                fillColor: Colors.black,
                filled: true,
              ),
            ),
            SizedBox(height: 20),
            Text('valor digitado é : ${result}'),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                if (valor < 10) {
                  print(aux[valor]);
                  result = aux[valor];
                } else if (valor < 20) {
                  print(cont[valor - 10]);
                  result = cont[valor - 10];
                } else if (valor <= 100) {
                  secondval = (valor / 10).floor();
                  int resto = (valor % 10);
                  if (resto > 0) {
                    print(number[secondval - 2] + ' e ' + aux[resto]);
                    result = number[secondval - 2] + ' e ' + aux[resto];
                  } else
                    print(number[secondval - 2]);
                  result = number[secondval - 2];
                } else if (valor > 100) {
                  print('valor não cadastrado');
                } else {
                  print('valor não cadastrado');
                }
              },
              child: Text('Enter'),
            )
          ]),
        ),
      ),
    );
  }
}
