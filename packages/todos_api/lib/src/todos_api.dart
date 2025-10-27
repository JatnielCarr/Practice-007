/// {@template todo}
/// A single todo item.
/// {@endtemplate}
class Todo {
  /// {@macro todo}
  const Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
  });

  /// The unique identifier for the todo.
  final String id;

  /// The title of the todo.
  final String title;

  /// The description of the todo.
  final String description;

  /// Whether the todo is completed.
  final bool isCompleted;

  /// Creates a copy of this todo with the given fields replaced.
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// {@template todos_api}
/// The interface for an API providing access to todos.
/// {@endtemplate}
abstract class TodosApi {
  /// {@macro todos_api}
  const TodosApi();

  /// Provides a [Stream] of all todos.
  Stream<List<Todo>> getTodos();

  /// Saves a [todo].
  Future<void> saveTodo(Todo todo);

  /// Deletes the todo with the given [id].
  Future<void> deleteTodo(String id);
}
