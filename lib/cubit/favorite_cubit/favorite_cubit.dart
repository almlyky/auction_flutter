import 'dart:convert';
import 'dart:developer';

import 'package:auction/core/api/links_api.dart';
import 'package:auction/core/service/services.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/data/models/favorite_model.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'favorite_state.dart';

class FavoriteCubit extends BaseCubit<List<FavoriteModel>> {
  final SharedRepository sharedRepository = SharedRepository();
  FavoriteCubit() {
    getFavorites();
  }
  Map<int, int> isfavorate = {};
  void initFavorites(List<PostModel> posts) {
    for (var post in posts) {
      isfavorate[post.id!] = post.fav!;
    }
  }
  setfavorate(id, value) {
    isfavorate[id] = value;
  }

  onTapFavorite(PostModel postModel) {
    // print("is favorite $isfavorate");

    if (isfavorate[postModel.id] == 0) {
      setfavorate(postModel.id, 1);
      addFavorite(postModel.id!);
      // addFavorite(productID: productModel.prId!);
    } else {
      setfavorate(postModel.id, 0);
      // removeFavorite(productID: productModel.prId!);
      deleteFavorite(postModel.id!);
    }
    // update();
  }

  getFavorites() async {
    await load(() async {
      int userId = Services.user!.id!;

      final result = await sharedRepository
          .getdata("${LinksApi.endpointFavorite}/$userId");
      List<FavoriteModel> favorites =
          (result as List).map((json) => FavoriteModel.fromJson(json)).toList();
      return favorites;
    });
    //   emit(FavoriteLoading());
    //   try {
    //     final data = await sharedRepository.getdata(LinksApi.endpointFavorite);
    //     List<FavoriteModel> favorites =
    //         (data as List).map((json) => FavoriteModel.fromJson(json)).toList();
    //     emit(FavoriteLoaded(favorites));
    //   } catch (e) {
    //     emit(FavoriteError(e.toString()));
    //   }
    // }
  }

  deleteFavorite(int postId) async {
    try {
      // emit(BaseLoading());
      await sharedRepository.deleteData("${LinksApi.endpointFavorite}/$postId");
      // Optionally, you can refresh the favorites list after deletion
      getFavorites();
      // emit(BaseInitial());
    } catch (e) {
      emit(BaseError(e.toString()));
    }
  }

  addFavorite(int postId) async {
    final favorite = state.data ?? [];
    await addData(() async {
      int userId = Services.user!.id!;

      final result = await sharedRepository.postData(
          LinksApi.endpointFavorite, {"post_id": postId, "user_id": userId});
      print("add favorite result: $result");
      // You can process the result if needed
      print("current favorites: $favorite");
      return [...favorite, FavoriteModel.fromJson(result)];
      // return result;
    });
  }
}
