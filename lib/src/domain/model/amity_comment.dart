import 'dart:async';

import 'package:amity_sdk/src/core/core.dart';
import 'package:amity_sdk/src/data/data.dart';
import 'package:amity_sdk/src/domain/domain.dart';

class AmityComment {
  AmityComment({required this.commentId});

  String? commentId;
  AmityCommentReferenceType? referenceType; //TODO: should be enum
  String? referenceId;
  String? userId;
  String? parentId;
  String? rootId;
  AmityDataType? dataType;
  AmityCommentData? data;
  int? childrenNumber;
  List<String>? repliesId;
  List<AmityComment>? latestReplies; //composer
  int? flagCount;
  List<String>? myReactions;
  int? reactionCount;
  AmityReactionMap? reactions; //composer
  Map<String, dynamic>? metadata;
  bool? isDeleted;
  DateTime? createdAt;
  DateTime? editedAt;
  DateTime? updatedAt;
  String? syncState;
  List<AmityMentionee>? mentionees; //composer
  AmityUser? user; //composer
  String? path;

  Stream<AmityComment> get listen {
    StreamController<AmityComment> controller =
        StreamController<AmityComment>();

    serviceLocator<CommentDbAdapter>()
        .listenCommentEntity(commentId!)
        .listen((event) {
      final _updateAmityComment = event.convertToAmityComment();

      //TOOD: Good idea would be have compose method inside the object itself
      serviceLocator<CommentComposerUsecase>().get(_updateAmityComment).then(
            (value) => controller.add(value),
          );
    });

    return controller.stream;
  }

  @override
  String toString() {
    return 'AmityComment(commentId: $commentId, referenceType: $referenceType, referenceId: $referenceId, userId: $userId, parentId: $parentId, rootId: $rootId, dataType: $dataType, data: $data, childrenNumber: $childrenNumber, repliesId: $repliesId, latestReplies: $latestReplies, flagCount: $flagCount, myReactions: $myReactions, reactionCount: $reactionCount, reactions: $reactions, isDeleted: $isDeleted, createdAt: $createdAt, editedAt: $editedAt, updatedAt: $updatedAt, syncState: $syncState, mentionees: $mentionees, user: $user, path: $path)';
  }

  @override
  get value => this;

  // @override
  // void dispose() {
  //   print('##### Disposing the stream subscription');
  //   _streamSubscription.cancel();
  //   super.dispose();
  // }
}

abstract class AmityCommentData {
  final String commentId;
  final String? fileId;
  final Map<String, dynamic>? rawData;
  late AmityFileInfo
      fileInfo; //Composer, Incase of Text post we dont have fileId, File Info or Raw Data

  AmityCommentData({required this.commentId, this.fileId, this.rawData});

  @override
  String toString() => 'AmityCommentData()';
}

class CommentTextData extends AmityCommentData {
  String? text;
  CommentTextData({
    required String commentId,
    this.text,
  }) : super(commentId: commentId);

  @override
  String toString() => 'TextData(commentId: $commentId, text: $text)';
}

class CommentImageData extends AmityCommentData {
  late AmityImage image; //composer
  CommentImageData({
    required String commentId,
    String? fileId,
    Map<String, dynamic>? rawData,
  }) : super(commentId: commentId, fileId: fileId, rawData: rawData);

  @override
  String toString() {
    return 'ImageData(commentId: $commentId, fileId: $fileId, rawData: $rawData, image: $image)';
  }
}

class CommentFileData extends AmityCommentData {
  late AmityFile file; //composer
  CommentFileData({
    required String commentId,
    String? fileId,
    Map<String, dynamic>? rawData,
  }) : super(commentId: commentId, fileId: fileId, rawData: rawData);
}

class CommentVideoData extends AmityCommentData {
  //FIXME: - some vidoe post dont have thubnail, we have to keep thubnail nullable instead of late.
  AmityImage? thumbnail; //composer
  CommentVideoData({
    required String commentId,
    String? fileId,
    Map<String, dynamic>? rawData,
  }) : super(
          commentId: commentId,
          fileId: fileId,
          rawData: rawData,
        );
}

class CommentLiveStreamData extends AmityCommentData {
  String? streamId;
  CommentLiveStreamData({
    required String commentId,
    required this.streamId,
    Map<String, dynamic>? rawData,
  }) : super(commentId: commentId, fileId: streamId, rawData: rawData);
}