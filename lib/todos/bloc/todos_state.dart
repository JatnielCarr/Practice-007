part of 'todos_bloc.dart';

enum TodosStatus { initial, loading, success, failure }

final class TodosState extends Equatable {
  const TodosState({
    this.status = TodosStatus.initial,
    this.todos = const [],
  });

  final TodosStatus status;
  final List<Todo> todos;

  TodosState copyWith({
    TodosStatus? status,
    List<Todo>? todos,
  }) {
    return TodosState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
    );
  }

  @override
  List<Object?> get props => [status, todos];
}
