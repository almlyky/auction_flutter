import 'package:auction/core/utils/enums.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/cubit/mypost_cubit/mypost_cubit.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/view/widget/handl_data_view.dart';
import 'package:auction/view/widget/home/posts/card_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPost extends StatelessWidget {
  const MyPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('اعلاناتي'),
        ),
        body: BlocBuilder<MypostCubit, BaseState<List<PostModel>>>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: BaseStateBuilder<List<PostModel>>(
                state: state,
                onLoaded: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final post = data[index];
                      return PostCard(post: post,mode: PostCardMode.owner,);
                    },
                  );
                },
                onInitial: const Center(child: Text('لا توجد اعلانات')),
                onRetry: () {
                  context.read<MypostCubit>().getData();
                },
              ),
            );
          },
        ));
  }
}
