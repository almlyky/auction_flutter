import 'package:auction/core/theme/app_colors.dart';
import 'package:auction/cubit/home_cubit/category_cubit/category_cubit.dart';
import 'package:auction/cubit/home_cubit/post_cubit/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.categories,
    required this.type,
  });
  final String type;
  final List categories;
  // final List<C> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final bool isAll = index == 0;
          // final category = categories[index-1];
          bool isSelected = type == "parent"
              ? context.read<CategoryCubit>().selectedindex == index
              : context.read<CategoryCubit>().selectedindexchildren == index;

          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              
              context.read<CategoryCubit>().changeSelectedIndex(index, type);
              if (isAll) {
                if (type == "child") {
                  int id=context
                      .read<CategoryCubit>()
                      .categoriesModel[context.read<CategoryCubit>().selectedindex-1]
                      .id!;
                  // print(
                  //     "===== selected parent index ===== ${id}");
                  // final category = categories[
                  //     context.read<CategoryCubit>().selectedindex-1];
                  //     print("===== category id ===== ${category.id}");
                  context
                      .read<PostCubit>()
                      .getPostByCategories(id, type);
                } else {
                  context.read<PostCubit>().children = [];
                  context.read<PostCubit>().getPost();
                }

                // ⭐ استرجاع كل البوستات بدون تصنيف
              } else {
                final category = categories[index - 1];
                context
                    .read<PostCubit>()
                    .getPostByCategories(category.id!, type);
              }
            },
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Center(
                child: Text(
                  isAll ? "الكل" : categories[index - 1].nameAr!,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
