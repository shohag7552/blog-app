import 'dart:math' as math;

import 'package:blog_project/core/widgets/glass_container.dart';
import 'package:blog_project/features/auth/bloc/auth_bloc.dart';
import 'package:blog_project/features/auth/pages/login_page.dart';
import 'package:blog_project/features/post_create/bloc/post_create_bloc.dart';
import 'package:blog_project/features/post_create/bloc/post_create_event.dart';
import 'package:blog_project/features/post_create/pages/post_create_page.dart';
import 'package:blog_project/features/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                // color: Colors.green,
              ),
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipOval(
                        child: Image.network(
                          'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Mehedi Hasan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.white60,
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Dhaka, Bangladesh',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white,),
              title: Text('Home', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_2_rounded, color: Colors.white),
              title: Text('Profile', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle, color: Colors.white),
              title: Text('Add Post', style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostCreatePage()),
                );
              },
            ),
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if(state is AuthUnauthenticated) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                }
              },
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.white,),
                title: Text('Log Out', style: TextStyle(color: Colors.white),),
                onTap: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
