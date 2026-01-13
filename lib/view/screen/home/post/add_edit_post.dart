import 'package:auction/core/service/services.dart';
import 'package:auction/core/utils/enums.dart';

import 'package:auction/core/utils/snackbar_helper.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/cubit/home_cubit/addPost_cubit/add_post_cubit.dart';
import 'package:auction/cubit/home_cubit/category_cubit/category_cubit.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:auction/view/widget/home/posts/custotextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditPost extends StatefulWidget {
  final PostAction postAction;
  final PostModel? post; // Add post parameter for edit mode

  const AddEditPost({super.key, required this.postAction, this.post});

  @override
  State<AddEditPost> createState() => _AddEditPostState();
}

class _AddEditPostState extends State<AddEditPost> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController address = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.postAction == PostAction.edit && widget.post != null) {
      name.text = widget.post!.name ?? '';
      description.text = widget.post!.discribtion ?? '';
      price.text = widget.post!.price?.toString() ?? '';
      address.text = widget.post!.address ?? '';

      // Initialize Cubit with post data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AddPostCubit>().setDataForEdit(
            widget.post!, context.read<CategoryCubit>().getCategoryById);
      });
    }
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    price.dispose();
    address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postAction == PostAction.add
            ? 'إضافة إعلان جديد'
            : "تعديل الاعلان"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AddPostCubit, AddPostState>(
          listener: (context, state) {
            if (state.status is BaseSuccess) {
              Navigator.pop(context);
            } else if (state.status is BaseError) {
              SnackbarHelper.showSnackbar((state.status as BaseError).message);
            }
          },
          builder: (context, state) {
            var cubit = context.read<AddPostCubit>();
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomTextFieldPost(
                        controller: name, label: 'عنوان الإعلان'),
                    const SizedBox(height: 10),
                    CustomTextFieldPost(
                        minLines: 5,
                        maxLines: 10,
                        controller: description,
                        label: 'وصف الإعلان'),
                    const SizedBox(height: 10),
                    CustomTextFieldPost(
                        controller: price,
                        label: 'السعر',
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 10),
                    CustomTextFieldPost(
                        controller: address, label: 'مكان المنتج'),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: state.selectedStatus,
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
                        if (val != null) cubit.changeStatus(val);
                      },
                      validator: (val) => val == null || val.isEmpty
                          ? 'اختر حالة المنتج'
                          : null,
                    ),

                    const SizedBox(height: 16),
                    // Category Dropdown - Simplified for now, ideally should be a separate widget that takes state
                    InkWell(
                      onTap: () => _openCategoryDialog(context, cubit),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: Services.prefs?.getBool("isDark") == true
                              ? Colors.black.withOpacity(0.03)
                              : Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Services.prefs?.getBool("isDark") == true
                                  ? Colors.white24
                                  : Colors.black26),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(state.selectedCategoryText,
                                style: const TextStyle(fontSize: 15)),
                            const Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Images
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...state.currentImages.asMap().entries.map((entry) {
                            int index = entry.key;
                            var image = entry.value;
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      image.imageUrl ?? "",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    child: IconButton(
                                        onPressed: () {
                                          cubit.deleteExistingImage(index);
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever_sharp,
                                          color: Colors.red,
                                        )))
                              ],
                            );
                          }),
                          ...state.newImages.asMap().entries.map((entry) {
                            int index = entry.key;
                            var file = entry.value;
                            return Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      file,
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
                                          cubit.deleteNewImage(index);
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever_sharp,
                                          color: Colors.red,
                                        )))
                              ],
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                cubit.selectPostImage();
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
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (state.status is BaseLoading)
                      const CircularProgressIndicator(),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if (state.selectedCategoryId == null) {
                            SnackbarHelper.showSnackbar("يرجى اختيار الفئة");
                            return;
                          }

                          if (widget.postAction == PostAction.add) {
                            cubit.addPost(
                              name: name.text,
                              description: description.text,
                              price: price.text,
                              address: address.text,
                            );
                          } else {
                            cubit.updatePost(
                              postId: widget.post!.id!,
                              name: name.text,
                              description: description.text,
                              price: price.text,
                              address: address.text,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(widget.postAction == PostAction.add
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

  void _openCategoryDialog(BuildContext context, AddPostCubit cubit) {
    List<CategoryModel> categories =
        context.read<CategoryCubit>().categoriesModel;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("اختر الفئة"),
        content: SizedBox(
          width: double.maxFinite,
          height: 350,
          child: ListView(
            children: categories.map((cat) {
              bool hasChildren =
                  cat.children != null && cat.children!.isNotEmpty;

              return hasChildren
                  ? ExpansionTile(
                      title: Text(cat.nameAr ?? ""),
                      children: cat.children!.map((child) {
                        return ListTile(
                          title: Text(child.nameAr ?? ""),
                          onTap: () {
                            cubit.selectedCategory(cat, child);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    )
                  : ListTile(
                      title: Text(cat.nameAr ?? ""),
                      onTap: () {
                        cubit.selectedCategory(cat, null);
                        Navigator.pop(context);
                      },
                    );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
