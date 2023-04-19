import 'package:flutter/material.dart';
import 'package:frontend/components/rounded_outlined_button.dart';
import 'package:frontend/pages/accounts/login_consumer.dart';
import 'package:frontend/utils/custom_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class AccountSetting extends StatefulWidget {
  const AccountSetting({
    super.key,
  });

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 8, left: 4, right: 4),
      color: Theme.of(context).colorScheme.onPrimary,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Log out',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SmallRoundedOutlinedTextButton(
              padding: EdgeInsets.zero,
              label: 'Log out',
              onPressed: () async {
                await Provider.of<Auth>(context, listen: false).logOut();
                if (!mounted) return;
                CustomRouter.pushReplacement(
                  context: context,
                  page: const LoginConsumer(),
                  animation: RouterAnimation.leftToRight,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
