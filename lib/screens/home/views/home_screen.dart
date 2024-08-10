import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_categorybloc/create_category_bloc.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_tracker/screens/home/blocs/get_expense_bloc/get_expenses_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:expense_tracker/screens/Stats/stats.dart';
import 'package:expense_tracker/screens/add_expense/views/add_expense.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
 Color selectedBar=Colors.blue;
 Color unselectedBar=Colors.grey;

  int index =0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
  builder: (context, state) {
    if(state is GetExpensesSuccess){
    return Scaffold(
      //appBar: AppBar(),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30)
        ),
        child: BottomNavigationBar(
          onTap: (value){
            setState(() {
              index=value;
            });
          },
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items:  [
            BottomNavigationBarItem(
                icon:Icon(CupertinoIcons.home,
                  color: index==0?selectedBar:unselectedBar,
                ),
              label: 'home',

            ),
            BottomNavigationBarItem(
                icon:Icon(CupertinoIcons.graph_square_fill,
                  color: index==1?selectedBar:unselectedBar,
                ),
              label: 'stats',

            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async{
         var newExpense = await Navigator.push(
            context,
            MaterialPageRoute<Expense>(
                builder: (BuildContext context) => MultiBlocProvider(
                 providers: [
                   BlocProvider(
                       create: (BuildContext context) => CreateCategoryBloc(FirebaseExpenseRepo()),

                   ),
                   BlocProvider(
                       create: (BuildContext context) => GetCategoriesBloc(FirebaseExpenseRepo())..add(GetCategories()),
                   ),
                   BlocProvider(
                     create: (BuildContext context) => CreateExpenseBloc(FirebaseExpenseRepo()),
                   ),
                 ],
                 child: const AddExpense(),
                )
            ),
          );
         if(newExpense != null){
           setState(() {
             state.expenses.insert(0,newExpense);
           });
         }
        },
        child: Container(
          child: const Icon(CupertinoIcons.plus
          ),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
              gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
                transform: const GradientRotation(pi/4),
            )
          ),
        ),
      ),
      body: index==0?MainScreen(state.expenses):StatScreen(),
    );
    }else {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

  },
);
  }
}
