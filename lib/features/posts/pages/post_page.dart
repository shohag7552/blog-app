import 'dart:developer';
import 'dart:math' as math;

import 'package:blog_project/core/utils/app_color.dart';
import 'package:blog_project/core/widgets/custom_snakebar.dart';
import 'package:blog_project/core/widgets/custom_text_field.dart';
import 'package:blog_project/core/widgets/post_card.dart';
import 'package:blog_project/features/favourite/bloc/favourite_bloc.dart';
import 'package:blog_project/features/favourite/bloc/favourite_event.dart';
import 'package:blog_project/features/favourite/bloc/favourite_state.dart';
import 'package:blog_project/features/favourite/pages/favourite_page.dart';
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
    context.read<FavouriteBloc>().add(LoadOnlyFavouritePostsIds());
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
      if (mounted && state is PostsLoaded && state.hasReachedMax) {
        log('Loading more posts...');
        context.read<PostBloc>().add(LoadPosts(loadMore: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.bgColor,
      endDrawer: DrawerWidget(),
      body: BlocBuilder<FavouriteBloc, FavouriteState>(
        builder: (context, favouriteState) {
          return BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostLoading && state.posts.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostError && state.posts.isEmpty) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is PostDeleted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  customSnakeBar(
                    context,
                    'Post deleted successfully',
                    isSuccess: true,
                  );
                  context.read<PostBloc>().add(LoadPosts());
                });
              } else if (state.posts.isEmpty) {
                return const Center(child: Text("No posts yet"));
              }
              return Stack(
                children: [
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
                      bool isFavourite = favouriteState.favouritePostIds.contains(state.posts[index].postId);
                      if (isFavourite) {
                        log('Post ${state.posts[index].postId} is favourite');
                      }
                      return PostCard(
                        postModel: state.posts[index],
                        isFavourite: isFavourite,
                      );
                    },
                  ),

                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 200,
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
                              LiquidGlass.withOwnLayer(
                                settings: LiquidGlassSettings(
                                  blur: 3,
                                  ambientStrength: 0.5,
                                  lightAngle: 0.2 * math.pi,
                                  glassColor: Colors.white12,
                                ),
                                shape: LiquidRoundedSuperellipse(
                                  borderRadius: 40,
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
                                  ),
                                ],
                              ),
                              const Spacer(),
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
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CustomTextField(
                              searchController: _searchController,
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search properties...',
                            ),
                          ),
                          const Spacer(),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 16,
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
                                    LiquidGlass.withOwnLayer(
                                      shape: LiquidRoundedSuperellipse(
                                        borderRadius: 40,
                                      ),
                                      glassContainsChild: false,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          children: [
                                            LiquidGlass.withOwnLayer(
                                              settings: LiquidGlassSettings(
                                                ambientStrength: 0.5,
                                                lightAngle: 0.2 * math.pi,
                                                glassColor: Colors.black26,
                                                thickness: 10,
                                                blur: 8,
                                              ),
                                              shape: LiquidRoundedSuperellipse(
                                                borderRadius: 40,
                                              ),
                                              glassContainsChild: false,
                                              child: InkWell(
                                                onTap: () {
                                                  context.read<PostBloc>().add(
                                                    LoadPosts(),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
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
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FavouritePage(),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Icon(
                                                  Icons.favorite_border_rounded,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    AnimatedSize(
                                      alignment: Alignment.center,
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeOut,
                                      child: SizedBox(
                                        width: _tabSpacing,
                                        height: 0,
                                      ),
                                    ),

                                    LiquidGlass.withOwnLayer(
                                      // blur: 3,
                                      shape: LiquidRoundedSuperellipse(
                                        borderRadius: 40,
                                      ),
                                      glassContainsChild: false,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PostCreatePage(),
                                            ),
                                          ).then((_) {
                                            context.read<PostBloc>().add(
                                              LoadPosts(),
                                            );
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 12,
                                          ),
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
                                              ),
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
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
