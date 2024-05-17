import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:meta/meta.dart';
import '../data/todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends HydratedBloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    on<StartedTodo>(_onStarted);
    on<AddTodo>(_onAdd);
    on<RemoveTodo>(_onRemove);
    on<ChangeTodo>(_onChange);
  }

  void _onStarted(
    StartedTodo event,
    Emitter<TodoState> emit,
  ) {
    if (state.status == TodoStatus.success) return;
    // Todo().initialData();
    emit(
      state.copyWith(
        todos: state.todos,
        status: TodoStatus.success,
      ),
    );
  }

  void _onAdd(
    AddTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(
        status: TodoStatus.loading,
      ),
    );
    try {
      state.todos.add(event.todo);
      emit(
        state.copyWith(
          todos: state.todos,
          status: TodoStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  void _onRemove(
    RemoveTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(
        status: TodoStatus.loading,
      ),
    );
    try {
      state.todos.remove(event.todo);
      emit(
        state.copyWith(
          todos: state.todos,
          status: TodoStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  void _onChange(
    ChangeTodo event,
    Emitter<TodoState> emit,
  ) {
    emit(
      state.copyWith(
        status: TodoStatus.loading,
      ),
    );
    try {
      state.todos[event.index].isDone = !state.todos[event.index].isDone;
      emit(
        state.copyWith(
          todos: state.todos,
          status: TodoStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TodoStatus.error,
        ),
      );
    }
  }

  @override
  TodoState? fromJson(Map<String, dynamic> json) {
    return TodoState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(TodoState state) {
    return state.toJson();
  }
}
