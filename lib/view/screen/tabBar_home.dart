import 'package:auction/view/screen/home/home.dart';
import 'package:flutter/material.dart';

class TabbarHome extends StatefulWidget {
  const TabbarHome({super.key});



  @override
  State<TabbarHome> createState() => _TabbarHomeState();

}

class _TabbarHomeState extends State<TabbarHome> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync:this);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TabBar Home Screen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Home'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
            Tab(icon: Icon(Icons.person), text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Home()),
          Center(child: Text('Settings Content')),
          Center(child: Text('Profile Content')),
        ],
      ),
    );
  }
}
