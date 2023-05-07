import 'package:flutter/material.dart';
import 'package:frontend/pages/reports_page/reports_page.dart';
import 'package:frontend/utils/custom_router.dart';

import '../../payment_history_page/components/add_payment_sheet.dart';
import '../../settings_page/settings_page.dart';
import '../groups_page.dart';

class GroupTile extends StatefulWidget {
  final Group group;
  const GroupTile({
    super.key,
    required this.group,
  });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  void _openGroupReport() => CustomRouter.push(
        context: context,
        page: SafeArea(
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
            body: ReportsPage(group: widget.group),
            floatingActionButton: Opacity(
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
            ),
          ),
        ),
        animation: RouterAnimation.leftToRight,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openGroupReport,
      child: Card(
        elevation: 1,
        color: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const Icon(
                      Icons.group,
                      color: Colors.purpleAccent,
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Text(
                        widget.group.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_outlined),
                onPressed: _openGroupReport,
              )
            ],
          ),
        ),
      ),
    );
  }
}
