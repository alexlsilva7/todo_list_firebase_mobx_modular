import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:todo_list_firebase_mobx_modular/app/modules/home/home_store.dart';
import 'package:todo_list_firebase_mobx_modular/app/modules/home/models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _showDialog({TodoModel? model}) {
    TodoModel todo = model ?? TodoModel();
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(model != null ? 'Editar' : 'Nova Tarefa'),
              content: TextFormField(
                initialValue: todo.title,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite o nome da tarefa',
                ),
                autofocus: true,
                onChanged: (value) {
                  todo.title = value;
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Modular.to.pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await todo.save();
                    Modular.to.pop();
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: Observer(
        builder: (context) {
          final store = Modular.get<HomeStore>();

          if (store.todoList == null || store.todoList?.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (store.todoList!.hasError) {
            return Center(
              child: ElevatedButton(
                child: const Text('Atualizar'),
                onPressed: () => store.getList(),
              ),
            );
          }
          List<TodoModel> list = store.todoList?.data;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: ((context, index) {
              TodoModel model = list[index];
              return ListTile(
                onTap: () => _showDialog(model: model),
                onLongPress: () => model.delete(),
                title: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    decoration: model.check
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: model.check
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).textTheme.bodyText1!.color,
                    fontSize: 18,
                  ),
                  child: Text(
                    model.title,
                  ),
                ),
                trailing: Checkbox(
                  value: model.check,
                  onChanged: (check) {
                    model.check = check!;
                    model.save();
                  },
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
