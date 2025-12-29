import 'dart:io';
import 'package:auction/core/service/services.dart';
import 'package:auction/core/utils/enums.dart';
import 'package:auction/core/utils/snackbar_helper.dart';
import 'package:auction/core/utils/utils.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/cubit/home_cubit/post_cubit/post_cubit.dart';
import 'package:auction/cubit/home_cubit/category_cubit/category_cubit.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:auction/view/widget/home/posts/custotextfield.dart';
import 'package:auction/view/widget/home/posts/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditPost extends StatelessWidget {
  final PostAction postAction;
  const AddEditPost({super.key, required this.postAction});

  @override
  Widget build(BuildContext context) {
    PostCubit cubit = context.read<PostCubit>();

    List<CategoryModel> categories =
        context.read<CategoryCubit>().categoriesModel;
    // selectedCategory ??= categories.isNotEmpty ? categories.first : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(postAction == PostAction.add
            ? 'إضافة إعلان جديد'
            : "تعديل الاعلان"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<PostCubit, BaseState<List<PostModel>>>(
          builder: (context, state) {
            // final images = state is PostImageSelected ? state.images : [];
            // print(
            //     "======================== reload PostCubit ========================= ");
            return Form(
              key: cubit.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    // الحقول النصية
                    CustomTextFieldPost(
                        controller: cubit.name, label: 'عنوان الإعلان'),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFieldPost(
                        minLines: 5,
                        maxLines: 10,
                        controller: cubit.description,
                        label: 'وصف الإعلان'),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFieldPost(
                        controller: cubit.price,
                        label: 'السعر',
                        keyboardType: TextInputType.number),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFieldPost(
                        controller: cubit.address, label: 'مكان المنتج'),
                    SizedBox(height: 10),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                    //   child: DropdownButtonFormField<String>(
                    //     initialValue: selectedStatus,
                    //     decoration: const InputDecoration(
                    //       labelText: 'الحالة',
                    //       border: OutlineInputBorder(),
                    //       contentPadding: EdgeInsets.symmetric(
                    //           horizontal: 12, vertical: 14),
                    //     ),
                    //     items: const [
                    //       DropdownMenuItem(
                    //           value: 'available', child: Text('متاح')),
                    //       DropdownMenuItem(value: 'sold', child: Text('تم البيع')),
                    //     ],
                    //     onChanged: (val) {
                    //       setState(() {
                    //         selectedStatus = val ?? 'available';
                    //       });
                    //     },
                    //     validator: (val) =>
                    //         val == null || val.isEmpty ? 'اختر الحالة' : null,
                    //   ),
                    // ),

                    DropdownButtonFormField<String>(
                      initialValue: cubit.selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'حالة المنتج',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'new', child: Text('جديد')),
                        DropdownMenuItem(value: 'used', child: Text('مستعمل')),
                      ],
                      onChanged: (val) {
                        // setState(() {
                        cubit.selectedStatus = val!;
                        // });
                      },
                      validator: (val) => val == null || val.isEmpty
                          ? 'اختر حالة المنتج'
                          : null,
                    ),

                    const SizedBox(height: 16),
                    CategoryDropdown(
                      categories: categories,
                    ),
                    const SizedBox(height: 16),

                    // عرض الصور المختارة
                    // if (context.read<PostCubit>().images.isNotEmpty)
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: context.read<PostCubit>().images.length + 1,
                        itemBuilder: (context, index) {
                          if (state is PostImageSelected) {
                            // print(
                            //     "===== PostImageSelected State with ${state.images.length} images =====");
                          }
                          if (index ==
                              context.read<PostCubit>().images.length) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<PostCubit>().selectPostImage();
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    context.read<PostCubit>().images[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        context
                                            .read<PostCubit>()
                                            .deleteImage(index);
                                      },
                                      icon: Icon(
                                        Icons.delete_forever_sharp,
                                        color: Colors.red,
                                      )))
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // عرض حالة التحميل أو الخطأ
                    if (state is BaseLoading)
                      const CircularProgressIndicator()
                    else if (state is BaseError)
                      Text(
                        'Error adding post: ${(state as BaseError).message}',
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 16),

                    // زر الإرسال
                    ElevatedButton(
                      onPressed: () {
                        // if (cubit.formKey.currentState!.validate() &&
                        //     context.read<PostCubit>().selectedId != null) {
                        //   PostModel post = PostModel(
                        //     name: name.text,
                        //     discribtion: description.text,
                        //     price: int.parse(price.text),
                        //     address: address.text,
                        //     userId: Services.user!.id!,
                        //     categoryId: context.read<PostCubit>().selectedId!,
                        //   );
                        if (postAction == PostAction.add) {
                          context.read<PostCubit>().addPost();
                        } else {
                          SnackbarHelper.showSnackbar("تعديل المنتج");
                        }
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(postAction == PostAction.add
                          ? 'إضافة الإعلان'
                          : "تعديل الاعلان"),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
