import 'package:blog_project/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';

import 'package:blog_project/core/widgets/glass_container.dart';
import 'package:flutter/material.dart';

// ----------------------------------------------------
// 1. New Widget to Contain the Dialog Logic and State
// ----------------------------------------------------
class CustomBottomSheetContent extends StatefulWidget {
  final Widget child;
  final Function(String)? onSubmit;
  final bool? forComment;
  const CustomBottomSheetContent({super.key, required this.child, this.onSubmit, this.forComment = false});

  @override
  State<CustomBottomSheetContent> createState() => _CustomBottomSheetContentState();
}

class _CustomBottomSheetContentState extends State<CustomBottomSheetContent> {
  // 2. Declare and initialize the controller in the State class
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    // 3. Dispose of the controller when the widget is removed
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This is the code from your original builder function
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return GlassContainer(
          borderRadius: 16.0,
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: widget.child, // Use widget.child
                ),
              ),

              // Input Field (now with the controller)
              if(widget.forComment??false)
                SafeArea(
                  top: false,
                  child: Padding( // Added padding here for better visual spacing
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      // 4. Assign the controller here
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          onPressed: () {
                            if (widget.onSubmit != null) {
                              widget.onSubmit!(_textController.text);
                            }
                            _textController.clear(); // Clear the input field
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------
// 5. Update the Original Function to Use the New Widget
// ----------------------------------------------------
void showCustomModalBottomSheet({required BuildContext context, required Widget child, Function(String)? onSubmit, bool? forComment}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return CustomBottomSheetContent(onSubmit: onSubmit, forComment: forComment, child: child);
    },
  );
}

// void showCustomModalBottomSheet({required BuildContext context, required Widget child}) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return DraggableScrollableSheet(
//         initialChildSize: 0.5,
//         minChildSize: 0.25,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return GlassContainer(
//             borderRadius: 16.0,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Container(
//                     width: 40,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//
//                 Expanded(
//                   child: SingleChildScrollView(
//                     controller: scrollController,
//                     child: child,
//                   ),
//                 ),
//
//                 SafeArea(
//                   top: false,
//                   child: TextField(
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: 'Type a message...',
//                       hintStyle: TextStyle(color: Colors.white60),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//                       suffixIcon: IconButton(
//                         icon: Icon(Icons.send, color: Colors.white),
//                         onPressed: () {
//                           // Handle send action
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }