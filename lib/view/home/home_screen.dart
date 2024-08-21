import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_task/bloc/cubit/login_cubit.dart';
import 'package:flutter_cubit_task/bloc/states/login_state.dart';
import 'package:flutter_cubit_task/core/app_export.dart';
import 'package:flutter_cubit_task/widgets/custom_elevated_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: BlocProvider(
        create: (context) => LoginCubit(FirebaseAuth.instance),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  // context.read<LoginCubit>().logOut();
                },
                child: CustomElevatedButton(
                  width: 184.h,
                  onPressed: () {
                    context.read<LoginCubit>().logOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User signed out successfully.')),
                    );
                    Navigator.pushReplacementNamed(context, AppRoutes.initialRoute);
                  },
                  text: "Log Out",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
