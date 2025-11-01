import 'dart:math' as math;

import 'package:blog_project/core/models/user_model.dart';
import 'package:blog_project/core/widgets/glass_container.dart';
import 'package:blog_project/core/widgets/glass_text.dart';
import 'package:blog_project/features/profile/bloc/profile_bloc.dart';
import 'package:blog_project/features/profile/bloc/profile_event.dart';
import 'package:blog_project/features/profile/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(LoadProfile('68d11523a769a7f519de'));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18391E),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Stack(
              children: [
                Image.network('https://wallpapers.com/images/hd/android-nature-dc04oabbkajt8l4t.jpg',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  color: Colors.black.withValues(alpha: 0.8),
                  colorBlendMode: BlendMode.darken,
                ),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return _buildProfileContent(user!);
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(UserModel user) {
    return Stack(
      children: [

        Image.network('https://wallpapers.com/images/hd/android-nature-dc04oabbkajt8l4t.jpg',
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          color: Colors.black.withValues(alpha: 0.8),
          colorBlendMode: BlendMode.darken,
        ),

        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 150, 16, 0),
          child: Column(
            children: [

              // 🔹 Profile Picture & Name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=3', // your image url
                      ),
                    ),
                    const SizedBox(height: 10),
                    GlassText(
                      text: user.name,
                      style: TextStyle(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GlassText(
                      text: user.userId,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Information section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   "About",
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   "Passionate Flutter developer with a focus on creating beautiful, high-performance apps using clean architecture and modern UI design.",
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.grey[700],
                    //   ),
                    // ),
                    // const SizedBox(height: 30),

                    const GlassText(
                      text: "Account Info",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _InfoTile(icon: Icons.email, label: "Email", value: user.email),
                    const SizedBox(height: 10),
                    _InfoTile(icon: Icons.phone, label: "Join", value: user.createdAt),
                    // _InfoTile(icon: Icons.location_on, label: "Location", value: "Dhaka, Bangladesh"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(children: [
              GlassContainer(
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  LiquidGlass.withOwnLayer(
                    // blur: 3,
                    settings: LiquidGlassSettings(
                      blur: 3,
                      ambientStrength: 0.5,
                      lightAngle: -0.2 * math.pi,
                      glassColor: Colors.white12,
                    ),
                    shape: LiquidRoundedSuperellipse(
                      borderRadius: 40,
                    ),
                    glassContainsChild: false,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 16),

                ]),
              ),

              const Spacer(),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent, size: 28),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        subtitle: Text(value, style: TextStyle(color: Colors.grey[300])),
      ),
    );
  }
}
