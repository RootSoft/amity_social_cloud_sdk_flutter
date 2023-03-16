import 'dart:io' if (dart.library.html) 'dart:html';

import 'package:amity_sdk/src/core/model/api_request/upload_file_request.dart';
import 'package:amity_sdk/src/domain/model/amity_file/amity_file_info.dart';
import 'package:amity_sdk/src/domain/model/amity_file/amity_upload_result.dart';
import 'package:amity_sdk/src/domain/usecase/file/file_audio_upload_usecase.dart';

class AmityAudioUploadQueryBuilder {
  final FileAudioUploadUsecase _usecase;
  final File _file;
  String? _uploadId;

  AmityAudioUploadQueryBuilder(this._usecase, this._file);

  void uploadId(String id) {
    _uploadId = id;
  }

  /* begin_public_function
  id: file.upload.audio
  */
  Future<AmityUploadResult<AmityAudio>> upload() {
    UploadFileRequest request = UploadFileRequest();
    request.files.add(_file);

    if (_uploadId != null) request.uploadId = _uploadId;

    return _usecase.get(request);
  }
  /* end_public_function */
}
