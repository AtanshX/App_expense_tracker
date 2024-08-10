import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/home/blocs/get_expense_bloc/get_expenses_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home/views/home_screen.dart';
class MyAppView extends StatelessWidget {
  const MyAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EXPENSE TRACKER',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade100,
          onBackground: Colors.black,
          outline: Colors.grey,
          primary: Color(0xFF00B2E7),
          secondary: Color(0xFFE064F7),
          tertiary: Color(0xFFFF8D6C)
        )
        ),
      home: BlocProvider(
    create: (context) => GetExpensesBloc(FirebaseExpenseRepo())..add(GetExpenses()),
    child:const Homescreen() ,

      ),);

  }
}






