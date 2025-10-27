import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_todos/todos/bloc/todos_bloc.dart';
import 'package:todos_api/todos_api.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosBloc(
        todosRepository: context.read(),
      )..add(const TodosSubscriptionRequested()),
      child: const TodosView(),
    );
  }
}

class TodosView extends StatelessWidget {
  const TodosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Javerage Todos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state.status == TodosStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TodosStatus.failure) {
            return const Center(
              child: Text('Error al cargar las tareas'),
            );
          }

          if (state.todos.isEmpty) {
            return const Center(
              child: Text(
                '¡No hay tareas!\nPresiona + para agregar una',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.todos.length,
            itemBuilder: (context, index) {
              final todo = state.todos[index];
              return TodoListTile(todo: todo);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final newTodo = Todo(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                );
                context.read<TodosBloc>().add(TodoAdded(newTodo));
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    required this.todo,
    super.key,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<TodosBloc>().add(TodoDeleted(todo));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${todo.title} eliminada'),
            action: SnackBarAction(
              label: 'Deshacer',
              onPressed: () {
                context.read<TodosBloc>().add(TodoAdded(todo));
              },
            ),
          ),
        );
      },
      child: CheckboxListTile(
        value: todo.isCompleted,
        onChanged: (value) {
          context.read<TodosBloc>().add(
                TodoCompletionToggled(
                  todo: todo,
                  isCompleted: value ?? false,
                ),
              );
        },
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: todo.description.isNotEmpty
            ? Text(
                todo.description,
                style: TextStyle(
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              )
            : null,
      ),
    );
  }
}
