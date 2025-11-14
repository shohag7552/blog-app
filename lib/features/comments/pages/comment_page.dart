import 'package:blog_project/features/comments/bloc/comment_bloc.dart';
import 'package:blog_project/features/comments/bloc/comment_event.dart';
import 'package:blog_project/features/comments/bloc/comment_state.dart' hide LoadComments;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class CommentPage extends StatefulWidget {
  final String postId;
  const CommentPage({super.key, required this.postId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {

  @override
  void initState() {
    super.initState();

    context.read<CommentBloc>().add(LoadComments(postId: widget.postId));
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, commentState) {
        if(commentState is CommentLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if(commentState is CommentError) {
          return Center(
            child: Text("Error: ${commentState.message}"),
          );
        } else if(commentState is CommentsLoaded) {
          if(commentState.comments.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: const Center(
                child: Text("No comments found.", style: TextStyle(color: Colors.white),),
              ),
            );
          }
          return ListView.builder(
            itemCount: commentState.comments.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final comment = commentState.comments[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100 * (((index + 3) % 8) + 1)],
                  child: Text("${index + 1}"),
                ),
                title: Text(
                  comment.user.name,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.content,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        comment.createdAt.toLocal().toString(),
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return SizedBox.shrink();
      }
    );
  }
}
