import 'package:auction/core/service/services.dart';
import 'package:auction/core/theme/app_colors.dart';
import 'package:auction/cubit/base_cubit/base_cubit.dart';
import 'package:auction/cubit/favorite_cubit/favorite_cubit.dart';
import 'package:auction/cubit/home_cubit/post_cubit/post_cubit.dart';
import 'package:auction/data/models/favorite_model.dart';
import 'package:auction/data/models/post_model.dart';
// import 'package:auction/view/widget/handl_data_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPost extends StatelessWidget {
  final PostModel post;
  const DetailsPost({super.key, required this.post});

  // int _currentImageIndex = 0;
  @override
  Widget build(BuildContext context) {
    // PostModel post = context.read<PostCubit>().postModel;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    print("isfavorite================ ${context.read<FavoriteCubit>().isfavorate}");

    // PostCubit cubit = context.read<PostCubit>();
    // cubit.isFavorite = post.fav == 1;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, post),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(theme, post),
                  const SizedBox(height: 16),
                  _buildSellerSection(theme, isDark),
                  const SizedBox(height: 16),
                  DescriptionSection(theme: theme, post: post),
                  const SizedBox(height: 24),
                  _buildAttributesSection(theme, isDark),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: BottomBar(theme: theme, isDark: isDark, post: post),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, PostModel post) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              itemCount: post.images?.length ?? 0,
              onPageChanged: (index) {
                context.read<PostCubit>().changeImageIndex(index);
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showFullScreenImage(context, index, post);
                  },
                  child: Image.network(
                    post.images![index].imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image,
                            size: 50, color: Colors.grey),
                      );
                    },
                  ),
                );
              },
            ),
            if ((post.images?.length ?? 0) > 0)
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${context.read<PostCubit>().currentImageIndex + 1} / ${post.images!.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, PostModel post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.name ?? 'بدون عنوان',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            post.productStatus == 'new' ? 'جديد' : 'مستعمل',
            // style: TextStyle(
            //   color: AppColors.primary,
            //   fontWeight: FontWeight.bold,
            //   fontSize: 12,
            // ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${post.price} ر.س',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              post.createdAt.toString().split(' ')[0],
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              post.address ?? 'غير محدد',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSellerSection(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.secondary.withOpacity(0.2),
            child: Icon(Icons.person, color: AppColors.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Services.user?.name ?? 'مستخدم',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  Services.user?.phone ?? '',
                  style:
                      theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Navigate to seller profile
            },
            icon: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributesSection(ThemeData theme, bool isDark) {
    // Placeholder for extra attributes if any
    return Container();
  }

  void _showFullScreenImage(
      BuildContext context, int initialIndex, PostModel post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PageView.builder(
            itemCount: post.images?.length ?? 0,
            controller: PageController(initialPage: initialIndex),
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  child: Image.network(
                    post.images![index].imageUrl ?? '',
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    super.key,
    required this.theme,
    required this.post,
  });

  final ThemeData theme;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الوصف',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          post.discribtion ?? 'لا يوجد وصف',
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.theme,
    required this.isDark,
    required this.post,
  });

  final ThemeData theme;
  final bool isDark;
  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
              onPressed: () async {
                final phone = Services.user?.phone;
                if (phone != null && phone.isNotEmpty) {
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: phone,
                  );
                  if (await canLaunchUrl(launchUri)) {
                    await launchUrl(launchUri);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('لا يمكن فتح تطبيق الهاتف')),
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('رقم الهاتف غير متوفر')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.call, color: Colors.white),
              label: const Text(
                'تواصل الآن',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          BlocBuilder<FavoriteCubit, BaseState<List<FavoriteModel>>>(
            builder: (context, state) {
              return Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<FavoriteCubit>().onTapFavorite(post);
                    // PostCubit cubit = context.read<PostCubit>();
                    // setState(() {
                    // if (cubit.isFavorite) {
                    //   cubit.isFavorite = false;
                    //   cubit.postModel.fav = 0;
                    //   context.read<FavoriteCubit>().deleteFavorite(post.id!);
                    // } else {
                    //   cubit.isFavorite = true;
                    //  cubit.postModel.fav = 1; // Update local post model
                    //   context.read<FavoriteCubit>().addFavorite(post.id!);
                    // }
                    // });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                        color:
                            context.read<FavoriteCubit>().isfavorate[post.id] ==
                                    1
                                ? AppColors.error
                                : Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Icon(
                    context.read<FavoriteCubit>().isfavorate[post.id] == 1
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        context.read<FavoriteCubit>().isfavorate[post.id] == 1
                            ? AppColors.error
                            : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
