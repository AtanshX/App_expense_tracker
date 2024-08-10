import 'package:flutter/material.dart';
import 'package:expense_tracker/screens/Stats/charts.dart';
class StatScreen extends StatelessWidget {
  const StatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
          child: Column(
            children: [
              const Text('Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              ),
              const SizedBox(height: 20,),
              Container(
                decoration:const BoxDecoration(
                  color: Colors.white,

                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: const Padding(
                padding: EdgeInsets.fromLTRB(12,20,12,12),
                    child: MyChart()
                ),
              )

            ],
          ),
        ) 
    );
  }
}
