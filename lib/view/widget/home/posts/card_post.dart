import 'package:auction/core/routes/app_routes.dart';
import 'package:auction/core/theme/app_colors.dart';
import 'package:auction/core/utils/enums.dart';
import 'package:auction/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:auction/cubit/home_cubit/post_cubit/post_cubit.dart';
import 'package:auction/cubit/mypost_cubit/mypost_cubit.dart';
import 'package:auction/data/models/post_model.dart';
import 'package:auction/view/screen/home/post/details_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Posts extends StatelessWidget {
  final ScrollController? scrollController;
  const Posts({
    super.key,
    required this.posts,
    this.scrollController,
  });

  final List<PostModel> posts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // physics: const NeverScrollableScrollPhysics(),
      controller: scrollController,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2, // يجعل البطاقة متناسقة الشكل
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(post: post);
      },
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionIcon({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.shadow,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final PostCardMode mode;
  const PostCard({
    super.key,
    required this.post,
    this.mode = PostCardMode.public,
  });

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final imageUrl = (post.images != null && post.images!.isNotEmpty)
        ? post.images!.first.imageUrl
        : null;
    // print("=================== imageUrl ================== $imageUrl");
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              // context.read<PostCubit>().postModel = post;
              return DetailsPost(post: post);
            },
          ),
        );
      },
      child: SizedBox(
        height: 150,
        child: Card(
          // elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنشور
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: imageUrl != null
                          ? Image.network(imageUrl
                              // Uri.encodeComponent(imageUrl),

                              // fit: BoxFit.cover,
                              )
                          : Icon(Icons.image_not_supported_outlined),
                    ),
                    if (mode == PostCardMode.owner)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            _ActionIcon(
                              icon: Icons.edit,
                              color: Colors.blue,
                              onTap: () {
                                context.read<PostCubit>().setDataForEdit(post);
                                context.push(AppRoutes.addEditPost,extra: PostAction.edit);
                              },
                            ),
                            const SizedBox(width: 6),
                            _ActionIcon(
                              icon: Icons.delete,
                              color: Colors.red,
                              onTap: () {
                                _confirmDelete(context, post.id!);
                              },
                            ),
                          ],
                        ),
                      ),

                    // شارة حالة المنتج (جديد / مستخدم)
                    if (context.read<PostCubit>().timeAgo(post.createdAt!) ==
                        "now")
                      Positioned(
                        top: 8,
                        // bottom: 0,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            // color: post.productStatus == "new"
                            //     ? AppColors.secondary
                            //     : Colors.orange.withOpacity(0.85),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                          ),
                          child: Text(
                            "now",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // تفاصيل المنتج
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.name ?? "No name",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.attach_money,
                                color: Colors.green, size: 18),
                            Text(
                              "${post.price ?? '--'}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.blueGrey, size: 16),
                            Text(
                              context
                                  .read<PostCubit>()
                                  .timeAgo(post.createdAt!),
                              // style: TextStyle(
                              //   color: Colors.grey[600],
                              //   fontSize: 13,
                              // )
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.red, size: 16),
                            Text(
                              post.address ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              // style: TextStyle(
                              //   color: Colors.grey[600],
                              //   fontSize: 13,
                              // ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _confirmDelete(BuildContext context, int postId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("حذف الإعلان"),
      content: const Text("هل أنت متأكد من حذف الإعلان؟"),
      actions: [
        TextButton(
          child: const Text("إلغاء"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("حذف"),
          onPressed: () {
            context.read<MypostCubit>().deletePost(postId);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
