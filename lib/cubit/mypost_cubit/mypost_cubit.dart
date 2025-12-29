import 'package:auction/core/api/links_api.dart';
import 'package:auction/core/service/services.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mypost_state.dart';

class MypostCubit extends BaseCubit<List<PostModel>> {
  SharedRepository sharedRepository = SharedRepository();
  MypostCubit() {
    getData();
  }

  getData() {
    int userId = Services.user!.id!;
    getMyPosts(userId);
  }

  getMyPosts(int userId) async {
    await load(() async {
      final data = await sharedRepository
          .getdata("${LinksApi.endpointPostByUser}/$userId");
      List<PostModel> posts =
          (data as List).map((json) => PostModel.fromJson(json)).toList();
      return posts;
    });
  }

  deletePost(int postId) async {
    final curent = state.data ??[];
    await deleteData(() async {
      await sharedRepository.deleteData("${LinksApi.endpointPosts}/$postId");
      curent.removeWhere((item) => item.id == postId);
      return [...curent];
    });
  }
}
