import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../utils/colors.dart';
import '../model/medical_video_model.dart';
import '../model/comment_model.dart';
import '../services/video_apis.dart';

class CommentsBottomSheet extends StatefulWidget {
  final MedicalVideo video;
  const CommentsBottomSheet({Key? key, required this.video}) : super(key: key);

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  List<CommentModel> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    setState(() => isLoading = true);
    final list = await VideoServiceApis.getVideoComments(widget.video.id);
    setState(() {
      comments = list;
      isLoading = false;
    });
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) return;
    String text = _commentController.text.trim();
    _commentController.clear();
    FocusScope.of(context).unfocus();
    
    try {
      await VideoServiceApis.postVideoComment(widget.video.id, text);
      await _fetchComments();
      widget.video.commentsCount++;
    } catch (e) {
      toast("Erreur lors de l'envoi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2), // Tiktok style leaves top space
      child: Column(
        children: [
          10.height,
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10))),
          20.height,
          Text("${widget.video.commentsCount} commentaires", style: boldTextStyle()),
          10.height,
          Divider(color: Colors.grey.withValues(alpha: 0.2)),
          
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : comments.isEmpty
                    ? Center(child: Text("Aucun commentaire pour l'instant", style: secondaryTextStyle()))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final c = comments[index];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(c.userImage.isNotEmpty ? c.userImage : 'https://via.placeholder.com/150'),
                              ),
                              10.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.userName, style: boldTextStyle(size: 13, color: c.userType == 'doctor' ? appColorPrimary : textPrimaryColorGlobal)),
                                    4.height,
                                    Text(c.comment, style: primaryTextStyle(size: 14)),
                                    10.height,
                                  ],
                                ),
                              )
                            ],
                          ).paddingBottom(10);
                        },
                      ),
          ),
          
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16, top: 10),
            decoration: BoxDecoration(
              color: context.cardColor,
              boxShadow: defaultBoxShadow(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _commentController,
                    textFieldType: TextFieldType.OTHER,
                    decoration: InputDecoration(
                      hintText: "Ajouter un commentaire...",
                      border: OutlineInputBorder(borderRadius: radius(20), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.grey.withValues(alpha: 0.1),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                  ),
                ),
                10.width,
                IconButton(
                  icon: const Icon(Icons.send, color: appColorPrimary),
                  onPressed: _postComment,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
