part of 'todos_bloc.dart';

sealed class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

final class TodosSubscriptionRequested extends TodosEvent {
  const TodosSubscriptionRequested();
}

final class TodoCompletionToggled extends TodosEvent {
  const TodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final Todo todo;
  final bool isCompleted;

  @override
  List<Object> get props => [todo, isCompleted];
}

final class TodoDeleted extends TodosEvent {
  const TodoDeleted(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}

final class TodoAdded extends TodosEvent {
  const TodoAdded(this.todo);

  final Todo todo;

  @override
  List<Object> get props => [todo];
}
