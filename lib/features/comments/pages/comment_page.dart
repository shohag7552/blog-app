import 'package:blog_project/features/comments/bloc/comment_bloc.dart';
import 'package:blog_project/features/comments/bloc/comment_event.dart';
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
    return ListView.builder(
      itemCount: 15,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue[100 * ((index % 8) + 1)],
            child: Text("${index + 1}"),
          ),
          title: Text(
            "Person ${index + 1}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            "You can't declare the controller directly in the function, as it would be created every time the builder runs, losing state. You need state management within the dialog itself.",
            style: TextStyle(color: Colors.white),
            maxLines: 2, overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.pop(context, "Item ${index + 1}");
          },
        );
      },
    );
  }
}
