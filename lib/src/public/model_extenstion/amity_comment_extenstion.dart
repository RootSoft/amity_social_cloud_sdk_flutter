import 'package:amity_sdk/src/core/core.dart';
import 'package:amity_sdk/src/domain/domain.dart';
import 'package:amity_sdk/src/public/query_builder/comment/comment_creator_builder.dart';
import 'package:amity_sdk/src/public/query_builder/comment/comment_flag_query_builder.dart';
import 'package:amity_sdk/src/public/query_builder/comment/comment_text_editor.dart';
import 'package:amity_sdk/src/public/query_builder/reaction/reaction_query_builder.dart';

extension AmityCommentExtension on AmityComment {
  AmityCommentCreateTargetSelector comment() {
    return AmityCommentCreateTargetSelector(
      useCase: serviceLocator(),
    ).post(referenceId!).parentId(commentId!);
  }

  AddReactionQueryBuilder react() {
    return AddReactionQueryBuilder(
        addReactionUsecase: serviceLocator(),
        removeReactionUsecase: serviceLocator(),
        referenceType: ReactionReferenceType.COMMENT.value,
        referenceId: commentId!);
  }

  CommentFlagQueryBuilder report() {
    return CommentFlagQueryBuilder(
        commentFlagUsecase: serviceLocator(),
        commentUnflagUsecase: serviceLocator(),
        commentId: commentId!);
  }

  Future delete({bool hardDelete = false}) {
    return serviceLocator<CommentDeleteUseCase>().get(commentId!);
  }

  AmityTextCommentEditorBuilder edit() {
    return AmityTextCommentEditorBuilder(
        useCase: serviceLocator(), targetId: commentId!);
  }
}