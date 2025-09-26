
import 'dart:io';

import 'package:blog_project/core/models/post_model.dart';
import 'package:blog_project/features/post_create/bloc/post_create_bloc.dart';
import 'package:blog_project/features/post_create/bloc/post_create_event.dart';
import 'package:blog_project/features/post_create/bloc/post_create_state.dart';
import 'package:blog_project/features/posts/bloc/posts_bloc.dart';
import 'package:blog_project/features/posts/bloc/posts_event.dart';
import 'package:blog_project/features/posts/bloc/posts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PostCreateView();
  }
}

class PostCreateView extends StatefulWidget {
  const PostCreateView({super.key});

  @override
  State<PostCreateView> createState() => _PostCreateViewState();
}

class _PostCreateViewState extends State<PostCreateView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();
    _tagController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Create Post',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          BlocBuilder<PostCreateBloc, PostCreateState>(
            // buildWhen: (previous, current) =>
            // previous.isFormValid != current.isFormValid ||
            //     previous.status != current.status,
            builder: (context, state) {
              return TextButton(
                onPressed: state is PostCreateLoading
                    ? null
                    : () => context.read<PostCreateBloc>().add(CreatePost(PostModel(
                  postId: '',
                  title: _titleController.text,
                  content: _contentController.text,
                  tags: ['hi'],
                  likes: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ))),
                child: state is PostLoading
                    ? const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(
                  'Post',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocListener<PostCreateBloc, PostCreateState>(
        listener: (context, state) {
          if (state is PostCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Post created successfully!")),
            );
            Navigator.pop(context); // Go back after success
          } else if (state is PostCreateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              _buildTitleInput(),
              const SizedBox(height: 20),

              // Content Input
              _buildContentInput(),
              const SizedBox(height: 20),

              // Images Section
              _buildImagesSection(),
              const SizedBox(height: 20),

              // Location Input
              _buildLocationInput(),
              const SizedBox(height: 20),

              // Tags Section
              _buildTagsSection(),
              const SizedBox(height: 100), // Bottom padding for scrolling
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _titleController,
        maxLength: 100,
        decoration: const InputDecoration(
          hintText: 'Post title...',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          counterText: '',
        ),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (value) {
          // context.read<PostCreateBloc>().add(PostTitleChanged(value));
        },
      ),
    );
  }

  Widget _buildContentInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _contentController,
        maxLines: 8,
        maxLength: 1000,
        decoration: const InputDecoration(
          hintText: "What's on your mind?",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        style: const TextStyle(fontSize: 16, height: 1.5),
        onChanged: (value) {
          // context.read<PostCreateBloc>().add(PostContentChanged(value));
        },
      ),
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.image, color: Colors.grey),
            const SizedBox(width: 8),
            const Text(
              'Photos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            _buildImagePickerButton(),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<PostCreateBloc, PostCreateState>(
          // buildWhen: (previous, current) => previous.images != current.images,
          builder: (context, state) {
            // if (state.images.isEmpty) {
            if (state is! PostCreateWithImages || state.images.isEmpty) {
              return Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, size: 32, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Add photos to your post', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              );
            }

            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: state.images.length,
                itemBuilder: (context, index) {
                  XFile imagePath = state.images[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(imagePath.path),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => context.read<PostCreateBloc>().add(RemoveImage(index)),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildImagePickerButton() {
    return PopupMenuButton<bool>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: false,
          child: Row(
            children: [
              Icon(Icons.photo_library),
              SizedBox(width: 8),
              Text('Gallery'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: true,
          child: Row(
            children: [
              Icon(Icons.camera_alt),
              SizedBox(width: 8),
              Text('Camera'),
            ],
          ),
        ),
      ],
      onSelected: (fromCamera) {
        if(!fromCamera) {
          context.read<PostCreateBloc>().add(PickImages());
          return;
        }
      },
    );
  }

  Widget _buildLocationInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _locationController,
        decoration: const InputDecoration(
          hintText: 'Add location...',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          prefixIcon: Icon(Icons.location_on, color: Colors.grey),
        ),
        onChanged: (value) {
          // context.read<PostCreateBloc>().add(PostLocationChanged(value));
        },
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.tag, color: Colors.grey),
            SizedBox(width: 8),
            Text(
              'Tags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _tagController,
            decoration: const InputDecoration(
              hintText: 'Add a tag and press enter...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              prefixIcon: Icon(Icons.tag, color: Colors.grey),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                // context.read<PostCreateBloc>().add(PostTagAdded(value.trim()));
                _tagController.clear();
              }
            },
          ),
        ),
        const SizedBox(height: 12),
        // BlocBuilder<PostCreateBloc, PostCreateState>(
        //   buildWhen: (previous, current) => previous.tags != current.tags,
        //   builder: (context, state) {
        //     if (state.tags.isEmpty) return const SizedBox.shrink();
        //
        //     return Wrap(
        //       spacing: 8,
        //       runSpacing: 8,
        //       children: state.tags.map((tag) {
        //         return Container(
        //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //           decoration: BoxDecoration(
        //             color: Colors.blue[50],
        //             borderRadius: BorderRadius.circular(20),
        //             border: Border.all(color: Colors.blue[200]!),
        //           ),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Text(
        //                 '#$tag',
        //                 style: TextStyle(
        //                   color: Colors.blue[700],
        //                   fontWeight: FontWeight.w500,
        //                 ),
        //               ),
        //               const SizedBox(width: 4),
        //               GestureDetector(
        //                 onTap: () => context
        //                     .read<PostCreateBloc>()
        //                     .add(PostTagRemoved(tag)),
        //                 child: Icon(
        //                   Icons.close,
        //                   size: 16,
        //                   color: Colors.blue[700],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       }).toList(),
        //     );
        //   },
        // ),
      ],
    );
  }
}