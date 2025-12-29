import 'dart:ui';

import 'package:auction/core/routes/app_routes.dart';
import 'package:auction/core/service/services.dart';
import 'package:auction/core/theme/app_colors.dart';
import 'package:auction/core/utils/enums.dart';
import 'package:auction/cubit/auth/login_cubit/login_cubit.dart';
import 'package:auction/cubit/bottom_app_bar_cubit/bottom_app_bar_cubit.dart';
import 'package:auction/cubit/setting_cubit/setting_cubit.dart';
import 'package:auction/view/screen/home/post/add_edit_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    final selectedColor = Theme.of(context).primaryColor;
    final unselectedColor = Colors.grey[600];
    return BlocBuilder<BottomAppBarCubit, BottomAppBarState>(
      builder: (context, state) {
        return Scaffold(
          drawer: const CustomDrawer(),
          appBar: AppBar(
            title: Text(context
                .read<BottomAppBarCubit>()
                .titleAppBar[context.read<BottomAppBarCubit>().selectedIndex]),
          ),
          body: context
              .read<BottomAppBarCubit>()
              .screans[context.read<BottomAppBarCubit>().selectedIndex],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
          floatingActionButton: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: () {
              context.push(AppRoutes.addEditPost,
                  extra: PostAction.add);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const AddEditPost(postAction: PostAction.add,)),
              // );
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: CustomBottomAppBar(
              selectedColor: selectedColor, unselectedColor: unselectedColor),
        );
      },
    );
  }
}

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    super.key,
    required this.selectedColor,
    required this.unselectedColor,
  });

  final Color selectedColor;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 65,
      shape: NotchedWithTopBorder(), // لدعم notch للفاب
      notchMargin: 16,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
              context.read<BottomAppBarCubit>().items.length + 1, (index) {
            final isSelected =
                index == context.read<BottomAppBarCubit>().selectedIndex;
            if (index == context.read<BottomAppBarCubit>().items.length) {
              return SizedBox(
                width: 45,
              );
            } else {
              final item = context.read<BottomAppBarCubit>().items[index];
              return Expanded(
                child: InkResponse(
                  onTap: () {
                    context.read<BottomAppBarCubit>().selectIndex(index);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: const Color.fromARGB(156, 74, 139, 106),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.icon,
                        size: 24,
                        color: isSelected ? selectedColor : unselectedColor,
                      ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   item.label,
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: isSelected ? selectedColor : unselectedColor,
                      //     fontWeight:
                      //         isSelected ? FontWeight.w600 : FontWeight.normal,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Services.user;
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: 0.65, // تصغير العرض أكثر
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(24)), // تغيير الحافة لليسار
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 45, left: 18, right: 18, bottom: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.85),
                    ],
                    begin: Alignment.topRight, // تغيير اتجاه التدرج
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24), // تغيير الحافة العلوية لليسار
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: Text(
                        user?.name?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D6A4F),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'اسم المستخدم',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.phone,
                                  size: 16, color: Colors.white70),
                              const SizedBox(width: 4),
                              Text(
                                user?.phone ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading:
                    Icon(Icons.home, color: Theme.of(context).primaryColor),
                title: const Text('الصفحة الرئيسية',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  // أضف التنقل المناسب هنا
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.settings, color: Theme.of(context).primaryColor),
                title: const Text('الإعدادات',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  // أضف التنقل المناسب هنا
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.campaign, color: Theme.of(context).primaryColor),
                title: const Text('اعلاناتي',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  context.push(AppRoutes.myPosts);
                  // أضف التنقل المناسب هنا
                },
              ),
              ListTile(
                leading: Icon(Icons.brightness_6,
                    color: Theme.of(context).primaryColor),
                title: const Text('تغيير الثيم',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                trailing: Switch(
                  value: context.watch<SettingCubit>().state == ThemeMode.dark,
                  onChanged: (val) {
                    // يفترض وجود ThemeCubit أو أي مزود لإدارة الثيم
                    context.read<SettingCubit>().toggleTheme();
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('تسجيل الخروج'),
                  onPressed: () {
                    context.read<LoginCubit>().logout(context);
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class NotchedWithTopBorder extends CircularNotchedRectangle {
  @override
  Path getOuterPath(Rect host, Rect? guest) {
    final path = super.getOuterPath(host, guest);

    // نرسم خط رفيع فوق البار
    final paint = Paint()
      ..color = Colors.black26
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    // نستخدم PathMetrics لعمل خط فوق المسار
    final metrics = path.computeMetrics();
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawPath(path, paint);

    return Path()..addPath(path, Offset.zero);
  }
}
