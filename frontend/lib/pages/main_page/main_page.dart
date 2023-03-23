import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page/home_page.dart';
import 'package:frontend/pages/settings_page/settings_page.dart';

import '../../utils/custom_router.dart';
import 'components/main_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage> {
  final _pageController = PageController();

  int pageSelected = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              splashRadius: 25,
              icon: const Icon(Icons.settings),
              onPressed: () => CustomRouter.push(
                context: context,
                page: const SettingsPage(),
                animation: RouterAnimation.rightToLeft,
              ),
            )
          ],
        ),
        drawer: MainDrawer(
          activePage: pageSelected,
        ),
        body: PageView(
          onPageChanged: (value) {
            setState(() => pageSelected = value);
          },
          children: const [
            HomePage(),
            Center(child: Text('Payments history')),
            Center(child: Text('Recurring payments')),
            Center(child: Text('Add proof of payment')),
            Center(child: Text('Groups')),
            Center(child: Text('Generate a report')),
            Center(child: Text('Set notifications')),
          ],
        ),
        floatingActionButton: Opacity(
          opacity: 0.9,
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              Icons.add_card,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}
