import 'package:auction/core/api/links_api.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:auction/view/screen/auth/login.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<BaseState> {
  SignupCubit() : super(BaseInitial());
  final GlobalKey<FormState> formSignupKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final SharedRepository sharedRepository = SharedRepository();

  @override
  Future<void> close() {
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    return super.close();
  }

  void signup(BuildContext context) async {
    if (formSignupKey.currentState!.validate()) {
      try {
        emit(BaseLoading());
        // Simulate a network call
        if (passwordController.text != confirmPasswordController.text) {
          emit(BaseError("Passwords do not match."));
          return;
        }
         await sharedRepository.postData(LinksApi.endpointSignup, {
          "name": nameController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
        });
        emit(BaseSuccess());
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } catch (e) {
        emit(BaseError(e.toString()));
      }
    }
  }
}
