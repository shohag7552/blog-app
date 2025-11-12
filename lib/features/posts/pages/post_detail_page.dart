import 'dart:ui';
import 'dart:math' as math;

import 'package:blog_project/core/utils/app_color.dart';
import 'package:blog_project/core/widgets/custom_snakebar.dart';
import 'package:blog_project/core/widgets/network_image.dart';
import 'package:blog_project/features/favourite/bloc/favourite_bloc.dart';
import 'package:blog_project/features/favourite/bloc/favourite_event.dart';
import 'package:blog_project/features/favourite/bloc/favourite_state.dart';
import 'package:blog_project/features/posts/bloc/posts_bloc.dart';
import 'package:blog_project/features/posts/bloc/posts_event.dart';
import 'package:blog_project/features/posts/bloc/posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPostDetail(widget.postId));
    context.read<FavouriteBloc>().add(LoadOnlyFavouritePostsIds());
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: BlocListener<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostDeleted) {
            customSnakeBar(context, 'Post deleted successfully', isSuccess: true);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<FavouriteBloc, FavouriteState>(
          builder: (context, favouriteState) {
            return BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is! PostDetailLoaded) {
                  return const Center(child: Text('Post not found'));
                }

                final post = state.post;
                final comments = state.comments;
                final isFavourite = favouriteState.favouritePostIds.contains(post.postId);

                return Stack(
                  children: [
                    CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        // App Bar
                        SliverAppBar(
                          expandedHeight: 300,
                          pinned: true,
                          backgroundColor: AppColor.bgColor,
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LiquidGlass.withOwnLayer(
                              settings: LiquidGlassSettings(
                                blur: 3,
                                ambientStrength: 0.5,
                                lightAngle: 0.2 * math.pi,
                                glassColor: Colors.white12,
                              ),
                              shape: LiquidRoundedSuperellipse(borderRadius: 40),
                              glassContainsChild: false,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LiquidGlass.withOwnLayer(
                                settings: LiquidGlassSettings(
                                  blur: 3,
                                  ambientStrength: 0.5,
                                  lightAngle: 0.2 * math.pi,
                                  glassColor: Colors.white12,
                                ),
                                shape: LiquidRoundedSuperellipse(borderRadius: 40),
                                glassContainsChild: false,
                                child: IconButton(
                                  icon: Icon(Icons.delete_forever, color: Colors.white),
                                  onPressed: () => _showDeleteDialog(context, post.postId!),
                                ),
                              ),
                            ),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (post.photos != null && post.photos!.isNotEmpty)
                                  CustomNetworkImage(imageUrl: post.photos!.first)
                                else
                                  Container(color: Colors.grey[800]),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColor.bgColor.withValues(alpha: 0.8),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Post Content
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title and Like Button
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        post.title ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        context.read<PostBloc>().add(LikePost(postId: post.postId!));
                                        await Future.delayed(Duration(milliseconds: 500));
                                        if (context.mounted) {
                                          context.read<FavouriteBloc>().add(LoadOnlyFavouritePostsIds());
                                          context.read<PostBloc>().add(LoadPostDetail(widget.postId));
                                        }
                                      },
                                      child: Icon(
                                        isFavourite ? Icons.favorite : Icons.favorite_border_rounded,
                                        color: isFavourite ? Colors.red : Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Author and Date
                                Row(
                                  children: [
                                    if (post.author != null) ...[
                                      Text(
                                        'By ${post.author?.name ?? 'Unknown'}',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '•',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Text(
                                      _formatDate(post.createdAt ?? DateTime.now()),
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Tags
                                if (post.tags != null && post.tags!.isNotEmpty)
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: post.tags!.map((tag) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                const SizedBox(height: 16),

                                // Content
                                Text(
                                  post.content ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Comments Section
                                Text(
                                  'Comments (${comments.length})',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),

                        // Comments List
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final comment = comments[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: LiquidGlass.withOwnLayer(
                                  settings: LiquidGlassSettings(
                                    blur: 3,
                                    ambientStrength: 0.5,
                                    lightAngle: 0.2 * math.pi,
                                    glassColor: Colors.white12,
                                  ),
                                  shape: LiquidRoundedSuperellipse(borderRadius: 20),
                                  glassContainsChild: false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                comment.user?.name ?? 'Anonymous',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              _formatDate(comment.createdAt, short: true),
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          comment.content,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: comments.length,
                          ),
                        ),

                        // Bottom Padding
                        SliverToBoxAdapter(
                          child: SizedBox(height: 100),
                        ),
                      ],
                    ),

                    // Comment Input (Fixed at bottom)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColor.bgColor.withValues(alpha: 0),
                              AppColor.bgColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: SafeArea(
                          child: LiquidGlass.withOwnLayer(
                            settings: LiquidGlassSettings(
                              ambientStrength: 2,
                              lightAngle: 0.4 * math.pi,
                              glassColor: Colors.black12,
                              thickness: 30,
                              blur: 4,
                            ),
                            shape: LiquidRoundedSuperellipse(borderRadius: 40),
                            glassContainsChild: false,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                    decoration: InputDecoration(
                                      hintText: 'Add a comment...',
                                      hintStyle: TextStyle(color: Colors.white60, fontSize: 15),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send, color: Colors.white),
                                  onPressed: () => _addComment(context, post.postId!),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _addComment(BuildContext context, String postId) {
    if (_commentController.text.trim().isEmpty) {
      customSnakeBar(context, 'Please enter a comment', isSuccess: false);
      return;
    }

    // TODO: Implement add comment functionality
    // You'll need to create a CommentBloc or add comment events to PostBloc
    customSnakeBar(context, 'Comment feature coming soon!', isSuccess: true);
    _commentController.clear();
  }

  void _showDeleteDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Delete Post"),
          content: Text("Are you sure you want to delete this post? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<PostBloc>().add(DeletePost(postId));
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date, {bool short = false}) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (short) {
      return '${months[date.month - 1]} ${date.day}';
    }
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
