import 'package:flutter/material.dart';
import 'package:frontend/pages/groups_page/components/add_group_sheet.dart';
import 'package:frontend/pages/home_page/components/no_data_widget.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../providers/group_provider.dart';
import 'components/group_tile.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  void fetchGroups() async {
    final provider = Provider.of<GroupProvider>(context, listen: false);
    if (provider.groups != null) return;
    try {
      await provider.fetchGroups();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            color: Theme.of(context).colorScheme.onPrimary,
            child: Consumer<GroupProvider>(
              builder: (context, provider, child) {
                final groups = provider.groups ?? [];

                if (groups.isEmpty) {
                  return const NoDataWidget(text: 'No groups to display.');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groups.length,
                  itemBuilder: (context, index) => GroupTile(
                    group: groups[index],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: Opacity(
        opacity: 0.85,
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () => showModalBottomSheet(
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
            builder: (context) => const AddGroupSheet(),
          ),
          child: Icon(
            Icons.group_add,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
