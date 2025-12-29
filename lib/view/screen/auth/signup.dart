import 'package:auction/core/utils/utils.dart';
import 'package:auction/cubit/auth/signup_cubit/signup_cubit.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/view/screen/auth/login.dart';
import 'package:auction/view/widget/auth/costomtextfiald.dart';
import 'package:auction/view/widget/handl_data_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    // bool visible = false;
    // Signupcontroler controler = Get.put(Signupcontroler());
    // Logincontrolers contrllog=Get.put(Logincontrolers());

    return Scaffold(
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: context.read<SignupCubit>().formSignupKey,
              child: ListView(
                children: [
                  // Container(
                  //     margin: EdgeInsets.only(top: 70),
                  //     child: const CircleAvatar(
                  //       radius: 50,
                  //       child: Icon(
                  //         Icons.person,
                  //         size: 50,
                  //       ),
                  //     )),
                  SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Text("إنشاء حساب",
                          style: Theme.of(context).textTheme.displaySmall),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: Text("مرحباً بك في منصتنا",
                          style: Theme.of(context).textTheme.bodyMedium)),

                  const SizedBox(
                    height: 60,
                  ),

                  //textfield username
                  customtextfaild(
                      valid: (value) {
                        return Utils.validateFormField(value);

                        // return validinput(
                        //     val!, 6, 100, "username", controler.erroremail);
                      },
                      typeinput: TextInputType.text,
                      controller: context.read<SignupCubit>().nameController,
                      hint: "الاسم",
                      checkpass: false,
                      icon: Icons.person),
                  const SizedBox(
                    height: 20,
                  ),

                  //textfield email
                  customtextfaild(
                      // errorText: controler.errorText,
                      valid: (value) {
                        return Utils.validateFormField(value);
                      },
                      typeinput: TextInputType.phone,
                      controller: context.read<SignupCubit>().phoneController,
                      hint: "الهاتف",
                      checkpass: false,
                      icon: Icons.phone),
                  const SizedBox(
                    height: 20,
                  ),

                  //textfield password
                  customtextfaild(
                      valid: (value) {
                        return Utils.validateFormField(value);
                      },
                      typeinput: TextInputType.text,
                      controller:
                          context.read<SignupCubit>().passwordController,
                      hint: "كلمة المرور",
                      checkpass: true,
                      icon: Icons.lock_open_outlined),
                  const SizedBox(
                    height: 20,
                  ),

                  //textfield password
                  customtextfaild(
                      valid: (value) {
                        return Utils.validateFormField(value);
                      },
                      typeinput: TextInputType.text,
                      controller:
                          context.read<SignupCubit>().confirmPasswordController,
                      hint: "تأكيد كلمة المرور",
                      checkpass: true,
                      icon: Icons.lock_open_outlined),
                  const SizedBox(
                    height: 40,
                  ),

                  //circle proccessing
                  // GetBuilder<Signupcontroler>(
                  //   init: Signupcontroler(),
                  //   builder: (contr) => Visibility(
                  //     visible: contr.visable,
                  //     child: const Center(child: CircularProgressIndicator()),
                  //   ),
                  // ),

                  //buttons create acounts

                  // AbsorbPointer(
                  //   absorbing: controler.load,
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           backgroundColor: controller.load
                  //               ? const Color.fromARGB(255, 140, 139, 139)
                  //               : Appcolor.buttoncolor),
                  //       onPressed: () {
                  //         controler.signupp();
                  //       },
                  //       child: controler.load
                  //           ? Lottie.asset("assets/lottie/loading.json",
                  //               height: 40, width: 40)
                  //           : Text("signup".tr)),
                  // ),

                  BlocBuilder<SignupCubit, BaseState>(
                    builder: (context, state) {
                      return BaseStateBuilder(
                        state: state,
                        onLoaded: (data) {
                          return ElevatedButton(
                              onPressed: () {
                                context.read<SignupCubit>().signup(context);
                              },
                              child: Text("إنشاء حساب"));
                        },
                        onInitial: ElevatedButton(
                            onPressed: () {
                              context.read<SignupCubit>().signup(context);
                            },
                            child: Text("إنشاء حساب")),
                      );
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("لديك حساب؟"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));

                            // Get.offNamed(AppRoute.login);
                          },
                          child: Text("تسجيل الدخول"))
                    ],
                  ),
                ],
              ),
            )));
  }
}
