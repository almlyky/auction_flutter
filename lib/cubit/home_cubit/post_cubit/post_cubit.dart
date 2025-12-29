import 'dart:convert';
import 'dart:io';

import 'package:auction/core/api/links_api.dart';
import 'package:auction/core/service/services.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/data/repositories/shared_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../base_cubit/base_cubit.dart';

part 'post_state.dart';

class PostCubit extends BaseCubit<List<PostModel>> {
  final SharedRepository sharedRepository;
  PostCubit(this.sharedRepository) : super() {
    getPost();
  }

  List<File> images = [];
  // List<PostModel> posts = [];
  String selectedStatus = 'used';
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController address = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PostModel postModel;
  int currentImageIndex = 0;
  bool isFavorite = false;
  List<PostModel> curent = [];
  // List<String> list = ['One', 'Two', 'Three', 'Four'];

  // CategoryModel? selectedCategory;
  // Children? selectchildren;

  // List<PostModel> postsByUser = [];

  late CategoryModel parent;
  Children? child;
  List<Children> children = [];
  int? selectedId;
  String selectedText = "اختر الفئة";

  
  void setDataForEdit(PostModel post) {
    postModel = post;
    name.text = post.name ?? '';
    description.text = post.discribtion ?? '';
    price.text = post.price != null ? post.price.toString() : '';
    address.text = post.address ?? '';
    selectedStatus = post.productStatus ?? 'used';
  }

  void addPost() async {
    print("======== Adding Post ========");
    if (formKey.currentState!.validate() && selectedId != null) {
      await addData(() async {
        print("======== Adding Post ========");
        PostModel post = PostModel(
          name: name.text,
          discribtion: description.text,
          price: int.parse(price.text),
          address: address.text,
          productStatus: selectedStatus,
          userId: Services.user!.id!,
          categoryId: selectedId!,
        );
        final data = post.toJson();
        var response = await sharedRepository.postDataWithMultiFile(
            LinksApi.endpointPosts, data, images);
        PostModel newpost = PostModel.fromJson(response);
        // final curent = state.data ?? [];
        return [...curent, newpost];
      });
    }
  }

  getPost() async {
    await load(() async {
      final data = await sharedRepository.getdata(LinksApi.endpointPosts);
      curent = (data as List).map((json) => PostModel.fromJson(json)).toList();
      return curent;
      // return fetchedPosts;
    });
  }

  getPostByCategories(int catId, String type) async {
    await load(() async {
      final data = await sharedRepository
          .getdata("${LinksApi.endpointCategories}/$catId");
      // List<PostModel>
      CategoryModel categoryModel = CategoryModel.fromJson(data['category']);
      if (type == "parent") {
        children = [];
      }
      if (categoryModel.children!.isNotEmpty) {
        children = categoryModel.children!;
      }
      // posts = fetchedPosts;
      return (data['posts'] as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
    });
  }

  // getPostByUser(int userId) async {
  //   await load(() async {
  //     // Fixed the string interpolation from original code which seemed to be a bug
  //     final data = await sharedRepository
  //         .getdata("${LinksApi.endpointPostByUser}/$userId");
  //     List<PostModel> fetchedPosts =
  //         (data as List).map((json) => PostModel.fromJson(json)).toList();
  //     postsByUser = fetchedPosts;
  //     return fetchedPosts;
  //   });
  // }

  void deleteImage(int index) {
    images = List<File>.from(images)..removeAt(index);
    emit(PostImageSelected(List.unmodifiable(images)));
  }

  void selectPostImage() async {
    final ImagePicker picker = ImagePicker();
    List<XFile> pickedfiles = await picker.pickMultiImage();
    if (pickedfiles.isEmpty) return;
    images = [...images, ...pickedfiles.map((e) => File(e.path))];
    emit(PostImageSelected(List.unmodifiable(images)));

    // List<File> newFiles = pickedfiles.map((image) => File(image.path)).toList();

    // if (newFiles.isNotEmpty) {
    //   if (images.isNotEmpty) {
    //     List<File> combinedImages = List<File>.from(images)..addAll(newFiles);
    //     // images = combinedImages;
    //     emit(PostImageSelected(combinedImages));
    //   } else {
    //     images = newFiles;
    //     emit(PostImageSelected(images));
    //   }
    // }
  }

  void selectedCategory(CategoryModel parent, Children? child) {
    selectedId = child?.id ?? parent.id;
    this.parent = parent;
    this.child = child;
    emit(PostCategorySelected(parent, child));
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60 || diff.inMinutes < 40) {
      return 'now';
    } else if (diff.inMinutes < 60) {
      return 'قبل ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'قبل ${diff.inHours} ساعة';
    } else if (diff.inDays < 30) {
      return 'قبل ${diff.inDays} يوم';
    } else if (diff.inDays < 365) {
      return 'قبل ${diff.inDays ~/ 30} شهر';
    } else {
      return 'قبل ${diff.inDays ~/ 365} سنة';
    }
  }

  changeImageIndex(int index) {
    currentImageIndex = index;
    // emit(PostImageIndexChanged(index));
  }

  @override
  Future<void> close() {
    name.dispose();
    description.dispose();
    price.dispose();
    address.dispose();
    return super.close();
  }
}
