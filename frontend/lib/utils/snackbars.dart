import 'package:flutter/material.dart';

void showExceptionSnackBar(BuildContext context, Exception e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '$e'.replaceAll('Exception: ', ''),
              style: Theme.of(context).textTheme.displaySmall,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      content: Row(
        children: [
          const Icon(Icons.done, color: Colors.green),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              msg,
              style: Theme.of(context).textTheme.displaySmall,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    ),
  );
}

void showForegroundMessageSnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.deepPurple,
      content: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.amber),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              msg,
              style: Theme.of(context).textTheme.displaySmall,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    ),
  );
}
