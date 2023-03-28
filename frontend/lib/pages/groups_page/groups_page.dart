import 'package:flutter/material.dart';
import 'package:frontend/pages/groups_page/components/add_group_sheet.dart';

import 'components/group_tile.dart';

class Group {
  final String name;

  Group({required this.name});
}

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  static List<Group> data = [
    Group(name: 'Friends'),
    Group(name: 'Family'),
    Group(name: 'Students'),
  ];

  List<Widget> _getRows() {
    return data.map((group) => GroupTile(group: group)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4,
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                children: _getRows(),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
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
