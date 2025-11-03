import 'package:blog_project/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Theme.of(context).textTheme.bodyLarge!.color,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 10),
          Text(
            'App Title',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Size get preferredSize => Size(700, 200);
}