import 'package:auction/core/api/crud.dart';
import 'package:auction/core/api/links_api.dart';
import 'package:auction/core/routes/app_routes.dart';
import 'package:auction/core/service/services.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/data/models/user_model.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:auction/view/screen/bottombar.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<BaseState> {
  LoginCubit() : super(BaseInitial());
  final GlobalKey<FormState> formLoginKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  SharedRepository sharedRepository = SharedRepository();

  void login(BuildContext context) async {
    if (formLoginKey.currentState!.validate()) {
      try {
        emit(BaseLoading());
        final result = await sharedRepository.postData(LinksApi.endpointLogin, {
          "phone": phoneController.text,
          "password": passwordController.text
        });
        String accessToken = result['access_token'];
        Services.saveToken(accessToken);
        SharedRepository newsharedRepository = SharedRepository();
        final userData =
            await newsharedRepository.postData(LinksApi.endpointUser, {});
        UserModel user = UserModel.fromJson(userData);
        Services.saveUser(user);

        emit(BaseSuccess(data: user));
        context.go(AppRoutes.index);
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => BottomBar()));
      } catch (e) {
        emit(BaseError(e.toString()));
      }
    }
  }

  void logout(BuildContext context) async {
    await Services.prefs?.clear();
    context.go(AppRoutes.login);
  }

  @override
  Future<void> close() {
    phoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
