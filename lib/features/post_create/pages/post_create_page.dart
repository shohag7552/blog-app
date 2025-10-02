
import 'dart:io';
import 'dart:math' as math;

import 'package:blog_project/core/models/post_model.dart';
import 'package:blog_project/core/widgets/circles.dart';
import 'package:blog_project/core/widgets/custom_snakebar.dart';
import 'package:blog_project/core/widgets/glass_container.dart';
import 'package:blog_project/core/widgets/glass_text_field_container.dart';
import 'package:blog_project/features/post_create/bloc/post_create_bloc.dart';
import 'package:blog_project/features/post_create/bloc/post_create_event.dart';
import 'package:blog_project/features/post_create/bloc/post_create_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class PostCreatePage extends StatelessWidget {
  const PostCreatePage({super.key});

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

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

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
      backgroundColor: const Color(0xFF18391E),
      body: Stack(children: [
        CirclesBackground(),

        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(16, 150, 16, 16),
          child: BlocListener<PostCreateBloc, PostCreateState>(
            listener: (context, state) {
              if (state.status == PostCreateStatus.success) {
                _titleController.clear();
                _contentController.clear();
                _locationController.clear();
                _tagController.clear();

                Navigator.pop(context);
                customSnakeBar(context, "Post created successfully!");
                // context.read<PostBloc>().add(LoadPosts(limit: 10, offset: 1));
              } else if (state.status == PostCreateStatus.failure) {
                customSnakeBar(context, state.errorMessage ?? "Failed to create post.", isSuccess: true);
              }
            },
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
                // _buildLocationInput(),
                // const SizedBox(height: 20),

                // Tags Section
                _buildTagsSection(),
                const SizedBox(height: 100), // Bottom padding for scrolling
              ],
            ),
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 170,
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
            child: Column(children: [
              Row(children: [
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
                const SizedBox(width: 16),

                Text(
                  'Create Post',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                BlocBuilder<PostCreateBloc, PostCreateState>(
                  builder: (context, state) {
                    return LiquidGlass(
                      settings: LiquidGlassSettings(
                        blur: 3,
                        ambientStrength: 0.5,
                        lightAngle: -0.2 * math.pi,
                        glassColor: Colors.white12,
                      ),
                      shape: LiquidRoundedSuperellipse(
                        borderRadius: const Radius.circular(10),
                      ),
                      glassContainsChild: false,
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: InkWell(
                          radius: 20,
                          onTap: state.status == PostCreateStatus.submitting
                              ? null
                              : () {
                            context.read<PostCreateBloc>().add(CreatePost(PostModel(
                              postId: '',
                              title: _titleController.text,
                              content: _contentController.text,
                              tags: state.tags,
                              likes: 0,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                              image: state.images,
                            )));

                            },
                          child: state.status == PostCreateStatus.submitting
                              ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: const SizedBox(
                                  width: 16, height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                              : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                            child: Text(
                              'Post',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

              ]),

              const Spacer(),
            ]),
          ),
        ),

      ]),
      /*appBar: AppBar(
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
                onPressed: state.status == PostCreateStatus.submitting
                    ? null
                    : () => context.read<PostCreateBloc>().add(CreatePost(PostModel(
                  postId: '',
                  title: _titleController.text,
                  content: _contentController.text,
                  tags: state.tags,
                  likes: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  image: state.images,
                ))),
                child: state.status == PostCreateStatus.submitting
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
          if (state.status == PostCreateStatus.success) {
            _titleController.clear();
            _contentController.clear();
            _locationController.clear();
            _tagController.clear();

            Navigator.pop(context);
            customSnakeBar(context, "Post created successfully!");
            // context.read<PostBloc>().add(LoadPosts(limit: 10, offset: 1));
          } else if (state.status == PostCreateStatus.failure) {
            customSnakeBar(context, state.errorMessage ?? "Failed to create post.", isSuccess: true);
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
              // _buildLocationInput(),
              // const SizedBox(height: 20),

              // Tags Section
              _buildTagsSection(),
              const SizedBox(height: 100), // Bottom padding for scrolling
            ],
          ),
        ),
      ),*/
    );
  }

  Widget _buildTitleInput() {

    return GlassTextFieldContainer(
      child: TextField(
        controller: _titleController,
        focusNode: _titleFocusNode,
        textInputAction: TextInputAction.next,
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
          color: Colors.white,
        ),
        onChanged: (value) {
          // context.read<PostCreateBloc>().add(PostTitleChanged(value));
        },
      ),
    );
  }

  Widget _buildContentInput() {
    return GlassTextFieldContainer(
      child: TextField(
        controller: _contentController,
        focusNode: _contentFocusNode,
        maxLines: 8,
        maxLength: 1000,
        decoration: const InputDecoration(
          hintText: "What's on your mind?",
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.white,
        ),
        onChanged: (value) {},
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
                color: Colors.white,
              ),
            ),
            const Spacer(),
            _buildImagePickerButton(),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<PostCreateBloc, PostCreateState>(
          // buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state.images.isEmpty) {
              return SizedBox(
                height: 120,
                child: GlassContainer(
                  // height: 120,
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[100],
                  //   borderRadius: BorderRadius.circular(12),
                  //   border: Border.all(color: Colors.grey[300]!),
                  // ),
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
                            onTap: () => context.read<PostCreateBloc>().add(PostImageRemoved(index)),
                            child: GlassContainer(
                              padding: const EdgeInsets.all(4),
                              // decoration: const BoxDecoration(
                              //   color: Colors.red,
                              //   shape: BoxShape.circle,
                              // ),
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
      color: Colors.white24,
      icon: GlassContainer(
        child: const Icon(Icons.add, color: Colors.white, size: 20),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: false,
          child: Row(
            children: [
              Icon(Icons.photo_library, color: Colors.white),
              SizedBox(width: 8),
              Text('Gallery', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: true,
          child: Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.white),
              SizedBox(width: 8),
              Text('Camera', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
      onSelected: (fromCamera) {
        if(!fromCamera) {
          context.read<PostCreateBloc>().add(PostImagesPicked());
          return;
        } else {
          customSnakeBar(context, 'Camera not supported yet', isSuccess: false);
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
            color: Colors.black.withValues(alpha: 0.05),
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
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        GlassTextFieldContainer(
          child: TextField(
            controller: _tagController,
            decoration: const InputDecoration(
              hintText: 'Add a tag and press enter...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              prefixIcon: Icon(Icons.tag, color: Colors.grey),
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                context.read<PostCreateBloc>().add(PostTagAdded(value.trim()));
                _tagController.clear();
              }
            },
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<PostCreateBloc, PostCreateState>(
          // buildWhen: (previous, current) => previous != current,
          builder: (context, state) {

            if (state.tags.isEmpty) return const SizedBox.shrink();

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.tags.map((tag) {
                return GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '#$tag',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => context
                            .read<PostCreateBloc>()
                            .add(PostTagRemoved(tag)),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}