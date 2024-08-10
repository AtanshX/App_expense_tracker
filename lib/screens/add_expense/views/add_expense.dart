import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/screens/add_expense/views/category_creation.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController=TextEditingController();
  TextEditingController categoryController=TextEditingController();

  TextEditingController dateController=TextEditingController();
  //DateTime selectDate=DateTime.now();
 late Expense expense;
 bool isLoading=false;
  @override
  void initState() {
    dateController.text=DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
    expense=Expense.empty;
    expense.expenseId=const Uuid().v1();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
  listener: (context, state) {
    if(state is CreateExpenseSuccess){
      Navigator.pop(context,expense);
    }else if(state is CreateExpenseLoading){
      isLoading=true;
    }
  },
  child: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
  builder: (context, state) {
    if(state is GetCategoriesSuccess){
    return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Add Expense',
              style: TextStyle(
               fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
              ),
              const SizedBox(height: 16,),

              SizedBox(
                width: MediaQuery.of(context).size.width*0.7,
                child: TextFormField(
                  controller: expenseController,
                  textAlignVertical: TextAlignVertical.center,
                  decoration:InputDecoration(
                    filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(FontAwesomeIcons.dollarSign, color: Colors.grey),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                    )
                  ),
                ),
              ),
              const SizedBox(height: 32,),
              TextFormField(
                readOnly: true,
                onTap: (){
                  
                },
                controller: categoryController,
                textAlignVertical: TextAlignVertical.center,
                decoration:InputDecoration(
                    filled: true,
                    fillColor: expense.category==Category.empty?Colors.white
                    : Color(expense.category.color),
                    hintText: 'Category',
                    suffixIcon: IconButton(color: Colors.grey,
                    icon: const Icon(FontAwesomeIcons.plus, color: Colors.grey,size: 16,),
                      onPressed: () async{
                        var newCategory = await getCategoryCreation(context);
                        print(newCategory);
                        setState(() {
                          state.categories.insert(0, newCategory);
                        });
                      }
                    ),
                    prefixIcon: expense.category==Category.empty?
                    const Icon(FontAwesomeIcons.list, color: Colors.grey,size: 16,)
                        :
                    Image.asset('assets/${ expense.category.icon}.png',scale: 2,),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12)
                      ),
                      borderSide: BorderSide.none,
                    )
                ),
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12)
                  ),
                    color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: state.categories.length,
                      itemBuilder: (context,i){
                        return Card(
                          child: ListTile(
                            onTap: (){
                              setState(() {
                                expense.category=state.categories[i];
                                categoryController.text=expense.category.name;
                              });
                            },
                            leading: Image.asset('assets/${state.categories[i].icon}.png',scale: 2,),
                            title: Text(state.categories[i].name),
                            tileColor: Color(state.categories[i].color),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            ),

                           ),
                        );


                      }


                  ),
                ),
              ),
              const SizedBox(height: 16,),
              TextFormField(
                controller: dateController,
                textAlignVertical: TextAlignVertical.center,
                readOnly: true,
                onTap: () async{
                  DateTime? newDate= await showDatePicker(context: context,
                      initialDate: expense.date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if(newDate!=null){
                    setState(() {
                      dateController.text=DateFormat('dd/MM/yyyy').format(newDate);
                      //selectDate=newDate;
                      expense.date=newDate;
                    });
                  }
                },
                decoration:InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(FontAwesomeIcons.clock, color: Colors.grey),
                    hintText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    )
                ),
              ),
              const SizedBox(height: 32 ,),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: kToolbarHeight,
                child: isLoading==true?const Center(child: CircularProgressIndicator())
                    :TextButton(
                    onPressed: (){
                        setState(() {
                          expense.amount=int.parse(expenseController.text);
                        });
                        context.read<CreateExpenseBloc>().add(CreateExpense(expense));
                                 },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      )
                    ),
                    child: const Text(
                        'Save',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    )
                ),
              )
            ],
          ),
        );
    }
    else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  },
),
      ),
    ),
);
  }
}
