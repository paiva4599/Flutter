import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => TarefaProvider(),
      child: const MyApp(),
    ),
  );
}

class Tarefa {
  final String id;
  final String titulo;

  Tarefa({required this.id, required this.titulo});
}

class TarefaProvider with ChangeNotifier {
  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => [..._tarefas];

  void adicionarTarefa(Tarefa tarefa) {
    _tarefas.add(tarefa);
    notifyListeners();
  }

  void removerTarefa(String id) {
    _tarefas.removeWhere((tarefa) => tarefa.id == id);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
      ),
      home: TelaPrincipal(), // Substitua MyHomePage(title: 'Flutter Demo Home Page') por TelaPrincipal
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TelaPrincipal extends StatelessWidget {
  final TextEditingController controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controlador,
              decoration: InputDecoration(labelText: 'Nova Tarefa'),
            ),
          ),
          ElevatedButton(
            child: Text('Adicionar'),
            onPressed: () {
              Provider.of<TarefaProvider>(context, listen: false).adicionarTarefa(Tarefa(id: DateTime.now().toString(), titulo: controlador.text));
              controlador.clear();
            },
          ),
          Expanded(
            child: Consumer<TarefaProvider>(
              builder: (ctx, tarefaProvider, _) => ListView.builder(
                itemCount: tarefaProvider.tarefas.length,
                itemBuilder: (ctx, i) => ListTile(
                  title: Text(tarefaProvider.tarefas[i].titulo),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Provider.of<TarefaProvider>(context, listen: false).removerTarefa(tarefaProvider.tarefas[i].id);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

