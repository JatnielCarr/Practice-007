import 'package:todos_api/todos_api.dart';

/// {@template todos_repository}
/// A repository that handles todo related requests.
/// {@endtemplate}
class TodosRepository {
  /// {@macro todos_repository}
  const TodosRepository({
    required TodosApi todosApi,
  }) : _todosApi = todosApi;

  final TodosApi _todosApi;

  /// Provides a [Stream] of all todos.
  Stream<List<Todo>> getTodos() => _todosApi.getTodos();

  /// Saves a [todo].
  Future<void> saveTodo(Todo todo) => _todosApi.saveTodo(todo);

  /// Deletes the todo with the given [id].
  Future<void> deleteTodo(String id) => _todosApi.deleteTodo(id);
}
