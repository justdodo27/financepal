import 'package:flutter/material.dart';
import 'package:frontend/pages/categories_page/categories_page.dart';
import 'package:frontend/pages/groups_page/groups_page.dart';
import 'package:frontend/pages/home_page/home_page.dart';
import 'package:frontend/pages/notifications_page/notifications_page.dart';
import 'package:frontend/pages/payment_history_page/payment_history_page.dart';
import 'package:frontend/pages/proofs_of_payments_page/proofs_of_payments_page.dart';
import 'package:frontend/pages/recurring_payments_page/recurring_payments_page.dart';
import 'package:frontend/pages/reports_page/reports_page.dart';
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
          onTabSelected: (value) => _pageController.jumpToPage(value),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            setState(() => pageSelected = value);
          },
          children: const [
            HomePage(),
            PaymentHistoryPage(),
            RecurringPaymentsPage(),
            CategoriesPage(),
            ProofsOfPaymentsPage(),
            GroupsPage(),
            ReportsPage(),
            NotificationsPage(),
          ],
        ),
        floatingActionButton: [0, 1, 2].contains(pageSelected)
            ? Opacity(
                opacity: 0.85,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.add_card,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
