import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:todos_api/todos_api.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc({
    required TodosRepository todosRepository,
  })  : _todosRepository = todosRepository,
        super(const TodosState()) {
    on<TodosSubscriptionRequested>(_onSubscriptionRequested);
    on<TodoCompletionToggled>(_onTodoCompletionToggled);
    on<TodoDeleted>(_onTodoDeleted);
    on<TodoAdded>(_onTodoAdded);
  }

  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequested(
    TodosSubscriptionRequested event,
    Emitter<TodosState> emit,
  ) async {
    emit(state.copyWith(status: TodosStatus.loading));

    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: TodosStatus.success,
        todos: todos,
      ),
      onError: (_, __) => state.copyWith(
        status: TodosStatus.failure,
      ),
    );
  }

  Future<void> _onTodoCompletionToggled(
    TodoCompletionToggled event,
    Emitter<TodosState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  Future<void> _onTodoDeleted(
    TodoDeleted event,
    Emitter<TodosState> emit,
  ) async {
    await _todosRepository.deleteTodo(event.todo.id);
  }

  Future<void> _onTodoAdded(
    TodoAdded event,
    Emitter<TodosState> emit,
  ) async {
    await _todosRepository.saveTodo(event.todo);
  }
}
