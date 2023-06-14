import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/loading_card.dart';
import '../../../providers/limit_provider.dart';
import '../../../utils/api/models/limit.dart';
import '../../../utils/snackbars.dart';
import '../../home_page/components/no_data_widget.dart';
import 'notification_tile.dart';

class UserNotificationsPage extends StatefulWidget {
  const UserNotificationsPage({
    super.key,
  });

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {
  Future<void> reloadLimits() async {
    final provider = Provider.of<LimitProvider>(context, listen: false);
    try {
      await provider.reloadLimits();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  void fetchLimits() async {
    final provider = Provider.of<LimitProvider>(context, listen: false);
    if (provider.limits != null) return;
    try {
      await provider.getLimits();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  void switchNotification(Limit limit, bool isActive) async {
    setState(() => limit.isActive = isActive);
    final provider = Provider.of<LimitProvider>(context, listen: false);
    try {
      await provider.updateLimit(limit);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLimits();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.tertiary,
      onRefresh: reloadLimits,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          Consumer<LimitProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const LoadingCard();
              }

              final limits = provider.limits!;
              if (limits.isEmpty) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 4,
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: const NoDataWidget(
                    text: 'No limits set up yet',
                  ),
                );
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4,
                color: Theme.of(context).colorScheme.onPrimary,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: limits.length,
                  itemBuilder: (context, index) => NotificationTile(
                    limit: limits[index],
                    onSwitch: (value) =>
                        switchNotification(limits[index], value),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 220)
        ],
      ),
    );
  }
}
