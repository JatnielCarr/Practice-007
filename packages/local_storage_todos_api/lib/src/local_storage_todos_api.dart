import 'package:todos_api/todos_api.dart';
import 'package:rxdart/rxdart.dart';

/// {@template local_storage_todos_api}
/// A Flutter implementation of the TodosApi that uses local storage.
/// {@endtemplate}
class LocalStorageTodosApi extends TodosApi {
  /// {@macro local_storage_todos_api}
  LocalStorageTodosApi() {
    _init();
  }

  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  void _init() {
    // Initialize with some example todos
    final todos = [
      const Todo(
        id: '1',
        title: 'Bienvenido a Javerage Todos',
        description: 'Esta es tu primera tarea',
      ),
      const Todo(
        id: '2',
        title: 'Toca para completar una tarea',
        description: 'Marca esta tarea como completada',
      ),
    ];
    _todoStreamController.add(todos);
  }

  @override
  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(Todo todo) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }
    _todoStreamController.add(todos);
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((t) => t.id == id);
    if (todoIndex == -1) {
      throw TodoNotFoundException();
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
    }
  }

  void dispose() => _todoStreamController.close();
}

/// Error thrown when a [Todo] with a given id is not found.
class TodoNotFoundException implements Exception {}
