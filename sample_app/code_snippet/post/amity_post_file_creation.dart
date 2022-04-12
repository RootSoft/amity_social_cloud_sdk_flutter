import 'dart:io';

import 'package:amity_sdk/lib.dart';

class AmityPostFileCreation {
  /* begin_sample_code
    gist_id: bd5a3d58f619c5fc89438b5a3ce33618
    filename: AmityPostFileCreation.dart
    asc_page: https://docs.amity.co/social/flutter
    description: Flutter create file post example
    */
 void uploadFile(File uploadinFile) {
    //first, upload file
    AmityCoreClient.newFileRepository()
        .file(uploadinFile)
        .upload()
        .then((AmityUploadResult<AmityFile> amityUploadResult) {
      //check if the upload result is complete
      if (amityUploadResult is AmityUploadComplete) {
        final amityUploadComplete = amityUploadResult as AmityUploadComplete;
        //cast amityUploadResult to AmityFile
        AmityFile uploadedFile = amityUploadComplete.getFile as AmityFile;
        //then create a file post
        createFilePost(uploadedFile);
      }
      //check if the upload result is complete
      else if (amityUploadResult is AmityUploadError) {
        final amityUploadError = amityUploadResult as AmityUploadError;
        final AmityException amityException = amityUploadError.getErrror;
        //handle error
      }
    });
  }

  void createFilePost(AmityFile uploadedFile) {
    AmitySocialClient.newPostRepository()
        .createPost()
        .targetUser('userId') // or targetMe(), targetCommunity(communityId: String)
        .file([uploadedFile])
        .text('Hello from flutter with file!')
        .post()
        .then((AmityPost post) => {
              //handle result
            })
        .onError((error, stackTrace) => {
              //handle error
            });
  }
  /* end_sample_code */
}