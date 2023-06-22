import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/colors.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/CommentService.dart';
import 'package:fortloom/domain/entities/CommentResource.dart';
import 'package:fortloom/domain/entities/PublicationCommentResource.dart';

import 'Comment.dart';

class CommetsDialog extends StatefulWidget {
  const CommetsDialog({Key? key, required this.postId}) : super(key: key);
  final int postId;
  @override
  State<CommetsDialog> createState() => _CommetsDialogState();
}

class _CommetsDialogState extends State<CommetsDialog> {
  AuthService authService = new AuthService();
  String username = "Usuario";
  int userId = 0;
  final TextEditingController _newCommentController = TextEditingController();
  final CommentService _commentService = CommentService();
  List<PublicationCommentResource> lstComments = [];

  Future<void> _pullRefresh() async {
    _commentService.getallByPostId(widget.postId).then((result) {
      setState(() {
        lstComments = result;
      });
    });
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  @override
  void initState() {
    super.initState();
    String tep;

    this.authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = this.authService.GetUsername(tep);

        this.authService.getperson(username).then((result) {
          setState(() {
            userId = result.id;
          });
        });
      });


    });

    _commentService.getallByPostId(widget.postId).then((result) {
      setState(() {
        lstComments = result;
      });
    });
  }

  Widget CommentForm() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text(
              'Make a Comment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(12),
          height: 4 * 15,
          child: TextField(
            controller: _newCommentController,
            maxLines: 4,
            decoration: InputDecoration(
              border: getBorder(false),
              enabledBorder: getBorder(false),
              focusedBorder: getBorder(true),
              hintText: "Enter a comment",
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(goldPrimary),
            ),
            onPressed: () {
              _commentService.addComment(
                  _newCommentController.text, widget.postId, userId);
              _newCommentController.clear();
            },
            child: const Text(
              'Comment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: ScreenWH(context).width * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            CommentForm(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: lstComments.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: _pullRefresh,
                      child: ListView.builder(
                          itemCount: lstComments.length,
                          itemBuilder: (context, index) {
                            return CommentWid(comment:lstComments[index]);
                          }),
                    )
                  : const Center(
                      child: Text("No comments"),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget CommetnWidget(PublicationCommentResource comment) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://source.unsplash.com/random/200x200?sig=${DateTime.now().millisecondsSinceEpoch}"),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                comment.userAccount.username,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
            child: Text(
              comment.commentdescription,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder getBorder(bool focused) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide:
          BorderSide(width: 2, color: focused ? Colors.black : borderGrey),
      gapPadding: 2,
    );
  }
}
