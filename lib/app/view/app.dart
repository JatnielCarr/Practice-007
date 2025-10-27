import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:javerage_todos/l10n/l10n.dart';
import 'package:javerage_todos/todos/todos.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_repository/todos_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodosRepository(
        todosApi: LocalStorageTodosApi(),
      ),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TodosPage(),
      ),
    );
  }
}
