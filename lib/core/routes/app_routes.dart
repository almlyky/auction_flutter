import 'package:auction/core/service/services.dart';
import 'package:auction/core/utils/enums.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/view/screen/auth/login.dart';
import 'package:auction/view/screen/auth/signup.dart';
import 'package:auction/view/screen/bottombar.dart';
import 'package:auction/view/screen/home/home.dart';
import 'package:auction/view/screen/home/post/add_edit_post.dart';
import 'package:auction/view/screen/home/post/details_post.dart' hide BottomBar;
import 'package:auction/view/screen/my_post.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final String addEditPost = "/addEditPost";
  static final String home = "/home";
  static final String login = "/login";
  static final String signup = "/signup";
  static final String index = "/";
  static final String postDetails = "/postdetails";
  static final String myPosts = "/myposts";

  static final GoRouter router = GoRouter(
    redirect: (context, state) {
      if (state.uri.toString() == index && Services.accessToken == null) {
        return login;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: addEditPost,
        builder: (context, state) {
          PostAction postAction = state.extra as PostAction;
          return AddEditPost(postAction: postAction);
        },
      ),
      GoRoute(path: home, builder: (context, state) => Home()),
      GoRoute(path: login, builder: (context, state) => Login()),
      GoRoute(path: index, builder: (context, state) => BottomBar()),
      GoRoute(path: signup, builder: (context, state) => Signup()),
      GoRoute(path: postDetails, builder: (context, state) => Home()),
      GoRoute(
          path: postDetails,
          builder: (context, state) {
            final PostModel post = state.extra as PostModel;
            return DetailsPost(
              post: post,
            );
          }),
      GoRoute(path: myPosts, builder: (context, state) => MyPost()),
      // أضف المزيد من الراوتات هنا إذا لزم الأمر
    ],
  );
}
