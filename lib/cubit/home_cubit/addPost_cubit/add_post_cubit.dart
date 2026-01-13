import 'dart:io';

import 'package:auction/core/api/links_api.dart';
import 'package:auction/core/service/services.dart';
import 'package:auction/core/utils/enums.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';

part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostState> {
  AddPostCubit() : super(const AddPostState());
  SharedRepository sharedRepository = SharedRepository();

  void setDataForEdit(PostModel post, Map<int, dynamic> categoryMap) async {
    List<Images> currentImages = post.images ?? [];
    List<File> newImages = [];
    List<int> deletedImageIds = [];

    String selectedCategoryText = "اختر الفئة";
    CategoryModel? selectedCategory;
    Children? selectedChildCategory;
    int? selectedCategoryId = post.categoryId;

    var categoryOrChild = categoryMap[post.categoryId];

    if (categoryOrChild is CategoryModel) {
      selectedCategory = categoryOrChild;
      selectedCategoryText = selectedCategory.nameAr ?? "";
    } else if (categoryOrChild is Children) {
      selectedChildCategory = categoryOrChild;
      var parent = categoryMap[categoryOrChild.parentId];
      if (parent is CategoryModel) {
        selectedCategory = parent;
        selectedCategoryText = "${parent.nameAr} → ${selectedChildCategory.nameAr}";
      }
    }

    emit(state.copyWith(
      currentImages: currentImages,
      // newImages: newImages,
      // deletedImageIds: deletedImageIds,
      selectedCategory: selectedCategory,
      selectedChildCategory: selectedChildCategory,
      selectedStatus: post.productStatus ?? 'used',
      selectedCategoryText: selectedCategoryText,
      selectedCategoryId: selectedCategoryId,
    ));
  }

  void addPost({
    required String name,
    required String description,
    required String price,
    required String address,
  }) async {
    if (state.selectedCategoryId != null) {
      emit(state.copyWith(status: BaseLoading()));
      try {
        PostModel post = PostModel(
          name: name,
          discribtion: description,
          price: int.parse(price),
          address: address,
          productStatus: state.selectedStatus,
          userId: Services.user!.id!,
          categoryId: state.selectedCategoryId!,
        );
        final data = post.toJson();
        var response = await sharedRepository.putOrPostDataWithMultiFile(
            LinksApi.endpointPosts, data, state.newImages);
        PostModel newpost = PostModel.fromJson(response);
        emit(state.copyWith(status: BaseSuccess(data: [newpost])));
      } catch (e) {
        emit(state.copyWith(status: BaseError(e.toString())));
      }
    }
  }

  void updatePost({
    required int postId,
    required String name,
    required String description,
    required String price,
    required String address,
  }) async {
    emit(state.copyWith(status: BaseLoading()));
    try {
      PostModel post = PostModel(
        id: postId,
        name: name,
        discribtion: description,
        price: int.parse(price),
        address: address,
        productStatus: state.selectedStatus,
        userId: Services.user!.id!,
        categoryId: state.selectedCategoryId!,
      );
      final data = post.toJson();
      data['_method'] = 'PUT';

      if (state.deletedImageIds.isNotEmpty) {
        for (int i = 0; i < state.deletedImageIds.length; i++) {
          data['deleted_images[$i]'] = state.deletedImageIds[i];
        }
      }

      var response = await sharedRepository.putOrPostDataWithMultiFile(
          "${LinksApi.endpointPosts}/$postId", data, state.newImages);
      PostModel updatedpost = PostModel.fromJson(response);
      emit(state.copyWith(status: BaseSuccess(data: [updatedpost])));
    } catch (e) {
      emit(state.copyWith(status: BaseError(e.toString())));
    }
  }

  void deleteExistingImage(int index) {
    if (index >= 0 && index < state.currentImages.length) {
      List<Images> currentImages = List.from(state.currentImages);
      List<int> deletedImageIds = List.from(state.deletedImageIds);

      if (currentImages[index].id != null) {
        deletedImageIds.add(currentImages[index].id!);
      }
      currentImages.removeAt(index);

      emit(state.copyWith(
        currentImages: currentImages,
        deletedImageIds: deletedImageIds,
      ));
    }
  }

  void deleteNewImage(int index) {
    if (index >= 0 && index < state.newImages.length) {
      List<File> newImages = List.from(state.newImages);
      newImages.removeAt(index);
      emit(state.copyWith(newImages: newImages));
    }
  }

  void selectPostImage() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> pickedfiles = await picker.pickMultiImage();
    if (pickedfiles.isEmpty) return;
    List<File> newImages = [
      ...state.newImages,
      ...pickedfiles.map((e) => File(e.path))
    ];
    emit(state.copyWith(newImages: newImages));
  }

  void selectedCategory(CategoryModel parent, Children? child) {
    int selectedId = child?.id ?? parent.id!;
    String selectedText = child != null
        ? "${parent.nameAr} → ${child.nameAr}"
        : parent.nameAr ?? "";

    emit(state.copyWith(
      selectedCategory: parent,
      selectedChildCategory: child,
      selectedCategoryId: selectedId,
      selectedCategoryText: selectedText,
    ));
  }

  void changeStatus(String status) {
    emit(state.copyWith(selectedStatus: status));
  }
}
