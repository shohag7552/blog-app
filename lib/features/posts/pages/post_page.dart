import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:blog_project/core/widgets/network_image.dart';
import 'package:blog_project/features/post_create/pages/post_create_page.dart';
import 'package:blog_project/features/posts/bloc/posts_bloc.dart';
import 'package:blog_project/features/posts/bloc/posts_event.dart';
import 'package:blog_project/features/posts/bloc/posts_state.dart';
import 'package:blog_project/features/posts/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  double _tabSpacing = 0.0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    if (offset > 100) {
      setState(() {
        _tabSpacing = 120;
      });
    } else {
      setState(() {
        _tabSpacing = 0;
      });
    }

    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final bloc = context.read<PostBloc>();
      final state = bloc.state;
      if(mounted && state is PostsLoaded && state.hasReachedMax) {
        log('Loading more posts...');
        context.read<PostBloc>().add(LoadPosts(loadMore: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF18391E),
      endDrawer: DrawerWidget(),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if(state is PostLoading && state.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is PostError && state.posts.isEmpty) {
            return Center(child: Text('Error: ${state.message}'));
          }
          else if (state.posts.isEmpty) {
            return const Center(child: Text("No posts yet"));
          }
            return Stack(children: [
              ListView.builder(
                  controller: _scrollController,
                  itemCount: state.posts.length,
                  padding: const EdgeInsets.only(
                    top: 188,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  itemBuilder: (context, index) {
                    if (index == state.posts.length) {
                      // show loader at bottom and fetch next page
                      // context.read<PostBloc>().add(LoadPosts(loadMore: true));
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: CustomNetworkImage(imageUrl: state.posts[index].photos != null && state.posts[index].photos!.isNotEmpty ? state.posts[index].photos?.first??'' : ''),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(36),
                                bottomRight: Radius.circular(36),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              state.posts[index].title??'',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Icon(
                                              Icons.favorite_border_rounded,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            // Icon(
                                            //   Icons.location_on_outlined,
                                            //   color: Colors.white60,
                                            //   size: 14,
                                            // ),
                                            // const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                state.posts[index].content??'',
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.tag,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              state.posts[index].tags?.join(', ')??'',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Icon(
                                            //   Icons.bathroom_outlined,
                                            //   color: Colors.white,
                                            //   size: 14,
                                            // ),
                                            // const SizedBox(width: 4),
                                            // Text(
                                            //   '${sampleHomes[index]
                                            //       .numberOfBathrooms} Baths',
                                            //   style: TextStyle(
                                            //     color: Colors.white,
                                            //     fontSize: 12,
                                            //   ),
                                            // ),
                                            // Spacer(),
                                            // Text(
                                            //   '\$ ${sampleHomes[index]
                                            //       .pricePerNight.toStringAsFixed(
                                            //       2)}/night',
                                            //   style: TextStyle(
                                            //     color: Colors.white,
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.w600,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF032343).withValues(alpha: 0),
                        Color(0xFF032343),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          LiquidGlass(
                            settings: LiquidGlassSettings(
                              blur: 3,
                              ambientStrength: 0.5,
                              lightAngle: 0.2 * math.pi,
                              glassColor: Colors.white12,
                            ),
                            shape: LiquidRoundedSuperellipse(
                              borderRadius: const Radius.circular(40),
                            ),
                            glassContainsChild: false,
                            child: Padding(
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
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                          const Spacer(),
                          LiquidGlass(
                            // blur: 3,
                            settings: LiquidGlassSettings(
                              blur: 3,
                              ambientStrength: 0.5,
                              lightAngle: -0.2 * math.pi,
                              glassColor: Colors.white12,
                            ),
                            shape: LiquidRoundedSuperellipse(
                              borderRadius: const Radius.circular(40),
                            ),
                            glassContainsChild: false,
                            child: InkWell(
                              onTap: () {
                                _scaffoldKey.currentState!.openEndDrawer();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: LiquidGlass(
                                settings: LiquidGlassSettings(
                                  ambientStrength: 2,
                                  lightAngle: 0.4 * math.pi,
                                  glassColor: Colors.black12,
                                  thickness: 30,
                                  blur: 4,
                                ),
                                shape: LiquidRoundedSuperellipse(
                                  borderRadius: const Radius.circular(40),
                                ),
                                glassContainsChild: false,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: TextField(
                                    controller: _searchController,
                                    focusNode: _searchFocusNode,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Search properties...',
                                      hintStyle: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 15,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.white60,
                                        size: 22,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16
                        ),
                        child: LiquidGlassLayer(
                          settings: LiquidGlassSettings(
                            ambientStrength: 0.5,
                            lightAngle: 0.2 * math.pi,
                            glassColor: Colors.white12,
                          ),
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LiquidGlass.inLayer(
                                  shape: LiquidRoundedSuperellipse(
                                    borderRadius: const Radius.circular(40),
                                  ),
                                  glassContainsChild: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        LiquidGlass(
                                          settings: LiquidGlassSettings(
                                            ambientStrength: 0.5,
                                            lightAngle: 0.2 * math.pi,
                                            glassColor: Colors.black26,
                                            thickness: 10,
                                            blur: 8,
                                          ),
                                          shape: LiquidRoundedSuperellipse(
                                            borderRadius:
                                            const Radius.circular(40),
                                          ),
                                          glassContainsChild: false,
                                          child: InkWell(
                                            onTap: () {
                                              context.read<PostBloc>().add(LoadPosts());
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.home_outlined,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                  Text(
                                                    'Home',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.favorite_border_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                AnimatedSize(
                                  alignment: Alignment.center,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  child: SizedBox(
                                    width: _tabSpacing,
                                    height: 0,
                                  ),
                                ),

                                LiquidGlass.inLayer(
                                  // blur: 3,
                                  shape: LiquidRoundedSuperellipse(
                                    borderRadius: const Radius.circular(40),
                                  ),
                                  glassContainsChild: false,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PostCreatePage()),
                                      ).then((_) {

                                        context.read<PostBloc>().add(LoadPosts());
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          Text(
                                            'Post',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // child: Padding(
                                    //   padding: const EdgeInsets.all(12.0),
                                    //   child: Icon(
                                    //     Icons.person_outline,
                                    //     color: Colors.white,
                                    //     size: 32,
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]);
        }
      ),
    );
  }
}
