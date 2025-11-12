import 'dart:ui';

import 'package:blog_project/core/models/post_model.dart';
import 'package:blog_project/core/widgets/custom_model_bottom_sheet.dart';
import 'package:blog_project/core/widgets/network_image.dart';
import 'package:blog_project/features/favourite/bloc/favourite_bloc.dart';
import 'package:blog_project/features/favourite/bloc/favourite_event.dart';
import 'package:blog_project/features/posts/bloc/posts_bloc.dart';
import 'package:blog_project/features/posts/bloc/posts_event.dart';
import 'package:blog_project/features/posts/pages/post_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PostCard extends StatelessWidget {
  final PostModel postModel;
  final bool isFavourite;
  const PostCard({super.key, required this.postModel, required this.isFavourite});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailPage(postId: postModel.postId!),
            ),
          ).then((_) {
            // Reload posts and favorites when returning from detail page
            context.read<PostBloc>().add(LoadPosts());
            context.read<FavouriteBloc>().add(LoadOnlyFavouritePostsIds());
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: CustomNetworkImage(imageUrl: postModel.photos != null && postModel.photos!.isNotEmpty ? postModel.photos?.first??'' : ''),
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
                            Expanded(
                              child: Text(
                                postModel.title??'',
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            IconButton(
                              icon: Icon(Icons.mode_comment_outlined, color: Colors.white, size: 24),
                              onPressed: () {
                                showCustomModalBottomSheet(
                                  context: context,
                                  child: ListView.builder(
                                    itemCount: 15,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.blue[100 * ((index % 8) + 1)],
                                          child: Text("${index + 1}"),
                                        ),
                                        title: Text("Item ${index + 1}", style: TextStyle(color: Colors.white),),
                                        subtitle: const Text("Tap to select", style: TextStyle(color: Colors.white)),
                                        onTap: () {
                                          Navigator.pop(context, "Item ${index + 1}");
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),

                            InkWell(
                              onTap: () async {
                                // Toggle the like/favorite
                                context.read<PostBloc>().add(LikePost(postId: postModel.postId!));

                                // Wait a bit for the like action to complete, then reload favorite IDs
                                await Future.delayed(Duration(milliseconds: 500));
                                if (context.mounted) {
                                  context.read<FavouriteBloc>().add(LoadOnlyFavouritePostsIds());
                                }
                              },
                              child: Icon(
                                isFavourite ? Icons.favorite : Icons.favorite_border_rounded,
                                color: isFavourite ? Colors.red : Colors.white,
                                size: 24,
                              ),
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
                                postModel.content??'',
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
                              postModel.tags?.join(', ')??'',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 10, right: 10,
              child: IconButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // backgroundColor: Colors.transparent,
                        title: Text("Delete Post"),
                        content: Text("Are you sure you want to delete this post? This action cannot be undone.",),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<PostBloc>().add(DeletePost(postModel.postId!));
                            },
                            child: Text("Delete", style: TextStyle(color: Colors.red),),
                          ),

                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Close"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete_forever, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
