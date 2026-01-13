import 'package:auction/core/routes/app_routes.dart';
import 'package:auction/core/service/services.dart';
import 'package:auction/core/theme/app_theme.dart';
import 'package:auction/core/utils/snackbar_helper.dart';
import 'package:auction/cubit/auth/login_cubit/login_cubit.dart';
import 'package:auction/cubit/auth/signup_cubit/signup_cubit.dart';
import 'package:auction/cubit/bottom_app_bar_cubit/bottom_app_bar_cubit.dart';
import 'package:auction/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:auction/cubit/home_cubit/category_cubit/category_cubit.dart';
import 'package:auction/cubit/home_cubit/post_cubit/post_cubit.dart';
import 'package:auction/cubit/mypost_cubit/mypost_cubit.dart';
import 'package:auction/cubit/setting_cubit/setting_cubit.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:auction/cubit/home_cubit/addPost_cubit/add_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Services.init();
  SharedRepository repository = SharedRepository();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => PostCubit(repository)),
      BlocProvider(
        create: (context) => CategoryCubit(repository),
      ),
      BlocProvider(
        create: (context) => BottomAppBarCubit(),
      ),
      BlocProvider(
        create: (context) => FavoriteCubit(),
      ),
      BlocProvider(
        create: (context) => LoginCubit(),
      ),
      BlocProvider(
        create: (context) => SignupCubit(),
      ),
      BlocProvider(
        create: (context) => SettingCubit(),
      ),
      BlocProvider(
        create: (context) => MypostCubit(),
      ),
      BlocProvider(
        create: (context) => AddPostCubit(),
      ),
    ],
    // create: (context) => PostCubit(repository),
    child: BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return MaterialApp.router(
          routerConfig: AppRoutes.router,
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar'),
          builder: (context, child) =>
              Directionality(textDirection: TextDirection.rtl, child: child!),
          theme: state is ThemeChanged && state.themeMode == ThemeMode.dark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          scaffoldMessengerKey: SnackbarHelper.messengerKey,
          // home: Login(),
        );
      },
    ),
  ));
}
