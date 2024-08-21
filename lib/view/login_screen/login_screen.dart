import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_task/bloc/cubit/login_cubit.dart';
import 'package:flutter_cubit_task/bloc/states/login_state.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => LoginCubit(FirebaseAuth.instance),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: SizeUtils.height,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.h, vertical: 18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(flex: 35),
                        Text(
                          "Log in!",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.displayMedium,
                        ),
                        Spacer(flex: 35),
                        CustomTextFormField(
                          controller: emailInputController,
                          hintText: "Email",
                          textInputType: TextInputType.emailAddress,
                          prefix: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 6.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgIcbaselinealternateemail,
                              height: 20.h,
                              width: 20.h,
                            ),
                          ),
                          prefixConstraints: BoxConstraints(maxHeight: 30.h),
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 6.h),
                        ),
                        SizedBox(height: 28.h),
                        CustomTextFormField(
                          controller: passwordInputController,
                          hintText: "Password",
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.visiblePassword,
                          prefix: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 6.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgBxslockopenalt,
                              height: 20.h,
                              width: 20.h,
                            ),
                          ),
                          prefixConstraints: BoxConstraints(maxHeight: 32.h),
                          obscureText: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 4.h, vertical: 6.h),
                        ),
                        SizedBox(height: 60.h),
                        CustomElevatedButton(
                          width: 184.h,
                          onPressed: () {
                            final email = emailInputController.text;
                            final password = passwordInputController.text;
                            context
                                .read<LoginCubit>()
                                .logInWithEmailAndPassword(email, password, context);
                          },
                          text: "Login",
                        ),
                        Spacer(flex: 64),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}
