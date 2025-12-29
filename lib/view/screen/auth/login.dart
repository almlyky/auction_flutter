// import 'package:eccommerce_new/controler/auth/logincontrolers.dart';
// import 'package:eccommerce_new/core/constant/colors.dart';
// import 'package:eccommerce_new/core/my_function/validinput.dart';
// import 'package:eccommerce_new/view/widget/login/costomtextfiald.dart';
import 'package:auction/core/utils/utils.dart';
import 'package:auction/cubit/auth/login_cubit/login_cubit.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/view/screen/auth/signup.dart';
import 'package:auction/view/widget/auth/costomtextfiald.dart';
import 'package:auction/view/widget/handl_data_view.dart';
import 'package:auction/view/widget/home/posts/custotextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    // Logincontrolers controler = Get.put(Logincontrolers());
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: context.read<LoginCubit>().formLoginKey,
          child: ListView(
            children: [
              SizedBox(
                height: 70,
              ),
              Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Text("تسجيل الدخول",
                        style: Theme.of(context).textTheme.displaySmall)),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Text(
                "مرحباً بك مجدداً",
                style: Theme.of(context).textTheme.bodyMedium,
              )),
              const SizedBox(
                height: 60,
              ),

              //textfield email
              // CustomTextFieldPost(controller: , label: label)
              customtextfaild(
                valid: (val) {
                  return Utils.validateFormField(val);
                },
                typeinput: TextInputType.emailAddress,
                controller: context.read<LoginCubit>().phoneController,
                hint: "الهاتف",
                icon: Icons.person,
                checkpass: false,
              ),
              const SizedBox(
                height: 20,
              ),
              //textfield password
              customtextfaild(
                  valid: (val) {
                    return Utils.validateFormField(val);
                  },
                  typeinput: TextInputType.text,
                  controller: context.read<LoginCubit>().passwordController,
                  hint: "كلمة المرور",
                  icon: Icons.lock_open_outlined,
                  checkpass: true),

              //textbutton forgetpassword
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                    onPressed: () {
                      // controler.gotoforget();
                    },
                    child: Text(
                      textAlign: TextAlign.start,
                      "هل نسيت كلمة المرور؟",
                    )),
              ),

              //button login
              // GetBuilder<Logincontrolers>(
              //   builder: (controlerlogin) => AbsorbPointer(
              //     absorbing: controler.load,
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: controler.load
              //               ? const Color.fromARGB(255, 140, 139, 139)
              //               : Appcolor.buttoncolor),
              //       onPressed: () {
              //         controler.login();
              //       },
              //       child: controlerlogin.load
              //           ? SizedBox(
              //               height: 50,
              //               width: 50,
              //               child: Lottie.asset("assets/lottie/loading.json"),
              //             )
              //           : Text("login".tr),
              //     ),
              //   ),
              // ),
              

              BlocBuilder<LoginCubit, BaseState>(
                builder: (context, state) {
                  return BaseStateBuilder(
                      state: state,
                      onLoaded: (data) {
                        return ElevatedButton(
                            onPressed: () {
                              context.read<LoginCubit>().login(context);
                            },
                            child: Text("تسجيل الدخول"));
                      },onInitial: ElevatedButton(
                            onPressed: () {
                              context.read<LoginCubit>().login(context);
                            },
                            child: Text("تسجيل الدخول")),
                      );
                },
              ),

              const SizedBox(
                height: 40,
              ),

              // Center(
              //     child: Text(
              //   "ت",
              //   style: const TextStyle(color: Colors.grey),
              // )),
              // const SizedBox(
              //   height: 20,
              // ),

              // //buttons authintecation
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     //  button facebook
              //     ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 20, vertical: 0),
              //           // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              //         ),
              //         onPressed: () {},
              //         child: const Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             Text(
              //               "f",
              //               style: TextStyle(fontSize: 30, fontFamily: "Cairo"),
              //             ),
              //             SizedBox(
              //               width: 20,
              //             ),
              //             Text(
              //               "facebook",
              //               style: TextStyle(fontSize: 20),
              //             )
              //           ],
              //         )),

              //     //button google
              //     ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 20, vertical: 0),

              //           backgroundColor: Colors.red,
              //           // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
              //         ),
              //         onPressed: () {
              //           controler.loginWithGoogle();
              //         },
              //         child: const Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             Text(
              //               "G",
              //               style: TextStyle(fontSize: 30, fontFamily: "Cairo"),
              //             ),
              //             SizedBox(
              //               width: 20,
              //             ),
              //             Text(
              //               "Google",
              //               style: TextStyle(fontSize: 20),
              //             )
              //           ],
              //         ))
              //   ],
              // ),
              // const SizedBox(
              //   height: 20,
              // ),

              //textbutton signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ليس لديك حساب؟"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signup()));
                        // controler.gotosignup();
                      },
                      child: Text("إنشاء حساب جديد"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
