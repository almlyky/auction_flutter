import 'package:auction/core/service/services.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/cubit/home_cubit/post_cubit/post_cubit.dart';
import 'package:auction/data/models/category_model.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDropdown extends StatelessWidget {
  final List<CategoryModel> categories;

  const CategoryDropdown({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, BaseState<List<PostModel>>>(
      builder: (context, state) {
        // String selectedText = "اختر الفئة";
        // int? selectedId;
        
        if (state is PostCategorySelected) {
          Children? child = context.read<PostCubit>().child;
          CategoryModel? parent = context.read<PostCubit>().parent;

          // selectedId = context.read<PostCubit>().selectedId;

          context.read<PostCubit>().selectedText = child != null
              ? "${parent.nameAr} → ${child.nameAr}"
              : parent.nameAr ?? "";
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "الفئة",
            //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            // ),
            // const SizedBox(height: 6),

            // ------ UI -------
            InkWell(
              onTap: () => _openDialog(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
                    Text(context.read<PostCubit>().selectedText,
                        style: const TextStyle(fontSize: 15)),
                    const Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),

            // if (selectedId != null) ...[
            //   const SizedBox(height: 10),
            //   Text("ID المختار: $selectedId"),
            // ]
          ],
        );
      },
    );
  }

  void _openDialog(BuildContext context) {
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
                      leading: const Icon(Icons.arrow_drop_down),
                      title: Text(cat.nameAr ?? ""),
                      children: cat.children!.map((child) {
                        return ListTile(
                          leading: const Icon(Icons.subdirectory_arrow_right),
                          title: Text(child.nameAr ?? ""),
                          onTap: () {
                            context
                                .read<PostCubit>()
                                .selectedCategory(cat, child);
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    )
                  : ListTile(
                      leading: const Icon(Icons.circle_outlined),
                      title: Text(cat.nameAr ?? ""),
                      onTap: () {
                        context.read<PostCubit>().selectedCategory(cat, null);
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
