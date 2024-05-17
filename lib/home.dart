import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app_bloc/bloc/todo_bloc.dart';
import 'package:todo_app_bloc/data/todo.dart';
import 'package:todo_app_bloc/my_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  addTodo(Todo todo) {
    context.read<TodoBloc>().add(AddTodo(todo));
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(RemoveTodo(todo));
  }

  changeTodo(int index) {
    context.read<TodoBloc>().add(ChangeTodo(index));
  }

  addTask() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller1 = TextEditingController();
        TextEditingController controller2 = TextEditingController();

        return AlertDialog(
          title: const Text(
            'Add a Task',
            style: TextStyle(fontSize: 24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextfield(
                controller: controller1,
                hintText: 'Task title..',
              ),
              const SizedBox(height: 10),
              MyTextfield(
                controller: controller2,
                hintText: 'Task description..',
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  addTodo(
                    Todo(
                      title: controller1.text,
                      subtitle: controller2.text,
                    ),
                  );
                  controller1.clear();
                  controller2.clear();
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Icon(Icons.check),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.secondary,
      appBar: AppBar(
        backgroundColor: color.primary,
        title: Text(
          'Todo App',
          style: TextStyle(
            color: color.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state.status == TodoStatus.success) {
                return ListView.separated(
                  itemCount: state.todos.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Positioned.fill(
                          child: Builder(
                            builder: (context) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Container(color: Colors.red),
                            ),
                          ),
                        ),
                        Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const BehindMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) =>
                                    removeTodo(state.todos[index]),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: color.background,
                            ),
                            child: ListTile(
                              title: Text(
                                state.todos[index].title,
                                style: TextStyle(
                                  color: Colors.black,
                                  decoration: state.todos[index].isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                state.todos[index].subtitle,
                                style: TextStyle(
                                  color: color.onBackground,
                                ),
                              ),
                              trailing: Checkbox(
                                value: state.todos[index].isDone,
                                onChanged: (_) => changeTodo(index),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else if (state.status == TodoStatus.initial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: Text('Error: ${state.status}'),
                );
              }
            },
          )),
    );
  }
}
