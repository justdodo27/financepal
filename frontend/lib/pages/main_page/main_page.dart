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
import 'components/add_payment_sheet.dart';
import 'components/main_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageController = PageController();

  int pageSelected = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String get title {
    switch (pageSelected) {
      case 1:
        return 'Payments';
      case 2:
        return 'Recurring payments';
      case 3:
        return 'Categories';
      case 4:
        return 'Proofs of payments';
      case 5:
        return 'Groups';
      case 6:
        return 'Reports';
      case 7:
        return 'Notifications';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .apply(color: Colors.white),
          ),
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
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                      ),
                      useSafeArea: true,
                      isScrollControlled: true,
                      builder: (context) => const AddPaymentSheet(),
                    );
                  },
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
