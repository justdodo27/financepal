import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          splashRadius: 25,
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            splashRadius: 25,
            icon: const Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          const BottomAppBar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CardTile(size: size),
                      CardTile(size: size),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CardTile(size: size),
                      CardTile(size: size),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CardTile(size: size),
                      CardTile(size: size),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomAppBar extends StatelessWidget {
  const BottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                '\$2500',
                style: Theme.of(context)
                    .textTheme
                    .apply(displayColor: Colors.white)
                    .displayLarge,
              ),
              Text(
                'Money spent',
                style: Theme.of(context)
                    .textTheme
                    .apply(bodyColor: Colors.white)
                    .bodyLarge,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 90),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Today',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 90),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'This month',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 100),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'This year',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      color: Theme.of(context).colorScheme.onPrimary,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: (size.width / 2) - 10, maxHeight: 200),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Hello world!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 20,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 40,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 50,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 80,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 40,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 60,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 20,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 70,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 20,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
