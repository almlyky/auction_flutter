import 'dart:convert';
import 'dart:math';

import 'package:auction/core/api/links_api.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/cubit/counter_cubit/counter_cubit.dart';
import 'package:auction/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:auction/cubit/home_cubit/category_cubit/category_cubit.dart';
import 'package:auction/cubit/home_cubit/post_cubit/post_cubit.dart';
// import 'package:auction/cubit/home_cubit/category_cubit/category_cubit.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/data/repositories/category_repository.dart';
import 'package:auction/view/screen/home/post/add_edit_post.dart';
import 'package:auction/view/screen/home/post/details_post.dart';
import 'package:auction/view/widget/handl_data_view.dart';
import 'package:auction/view/widget/home/card_category.dart';
import 'package:auction/view/widget/home/posts/card_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController scrollController;
  bool isVisible = true;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // تحديد ما إذا كان المستخدم يمرر للأسفل
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      print("scrolling down $isVisible");

      // إذا كان مرئياً، اجعله غير مرئي
      if (isVisible) {
        setState(() {
          isVisible = false;
        });
      }
    }
    // تحديد ما إذا كان المستخدم يمرر للأعلى
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      print("scrolling up $isVisible");
      // إذا كان غير مرئي، اجعله مرئيًا
      if (!isVisible) {
        setState(() {
          isVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const AddEditPost()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
      // appBar: AppBar(
      //   title: const Text('الصفحة الرئيسية'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              switchInCurve: Curves.fastEaseInToSlowEaseOut,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: isVisible
                  ? Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                              // alignLabelWithHint: true,

                              prefixIcon: IconButton(
                                  icon: Icon(Icons.search), onPressed: () {}),
                              suffixIcon: Icon(Icons.filter_list),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintText: "ابحث عن إعلان",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<CategoryCubit,
                            BaseState<List<CategoryModel>>>(
                          builder: (context, state) {
                            return BaseStateBuilder<List<CategoryModel>>(
                              state: state,
                              onRetry: () {
                                context.read<CategoryCubit>().fetchCategories();
                              },
                              onLoaded: (categories) {
                                return BlocBuilder<PostCubit,
                                    BaseState<List<PostModel>>>(
                                  builder: (context, state) {
                                    return Column(
                                      children: [
                                        Categories(
                                          categories: categories,
                                          type: "parent",
                                        ),
                                        SizedBox(height: 10),
                                        if (context
                                            .read<PostCubit>()
                                            .children
                                            .isNotEmpty)
                                          Categories(
                                            categories: context
                                                .read<PostCubit>()
                                                .children,
                                            type: "child",
                                          ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ) // يظهر
                  : SizedBox.shrink(), // يختفي تمامًا
            ),

            // AnimatedOpacity(
            //   duration: const Duration(milliseconds: 300), // مدة حركة التحول
            //   opacity: isVisible ? 1.0 : 0.0,
            //   // curve: Curves.easeInOut,
            //   // child:,
            // ),
            // TextFormField(
            //   decoration: InputDecoration(
            //       // alignLabelWithHint: true,

            //       prefixIcon:
            //           IconButton(icon: Icon(Icons.search), onPressed: () {}),
            //       suffixIcon: Icon(Icons.filter_list),
            //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
            //       hintText: "ابحث عن إعلان",
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(8))),
            // ),

            SizedBox(
              height: 10,
            ),
            // وضع هذا في المكان المشار إليه (يتيح إخفاء/إظهار الأقسام عند التمرير)

            Expanded(
              child: BlocConsumer<PostCubit, BaseState<List<PostModel>>>(
                listener: (context, state) {
                  if (state is BaseSuccess) {
                    context.read<FavoriteCubit>().initFavorites(state.data!);
                  }
                },
                builder: (context, state) {
                  // if (state is BaseAdded) {
                  //   final posts = context.read<PostCubit>().posts;
                  //   return Posts(
                  //     posts: posts,
                  //     scrollController: scrollController,
                  //   );
                  // }

                  return BaseStateBuilder<List<PostModel>>(
                    state: state,
                    onRetry: () {
                      context.read<PostCubit>().getPost();
                    },
                    onLoaded: (posts) {
                      if (posts.isNotEmpty) {
                        return Posts(
                          posts: posts,
                          scrollController: scrollController,
                        );
                      } else {
                        return Center(child: Text("Not Found Posts"));
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
