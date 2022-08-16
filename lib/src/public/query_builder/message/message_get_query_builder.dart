import 'package:amity_sdk/src/core/core.dart';
import 'package:amity_sdk/src/domain/domain.dart';
import 'package:amity_sdk/src/domain/model/message/amity_message.dart';
import 'package:amity_sdk/src/domain/usecase/message/message_query_use_case.dart';

/// [MessageGetQueryBuilder]
class MessageGetQueryBuilder {
  /// UseCase
  late MessageQueryUseCase _useCase;

  late MessageQueryRequest _request;

  bool _stackFromEnd = true;
  String? _parentId;
  bool? _isFilterByParentId = false;
  AmityTags? _includingTags;
  AmityTags? _excludingTags;
  bool? _isDeleted;

  /// [MessageGetQueryBuilder]
  MessageGetQueryBuilder(MessageQueryUseCase useCase, String channelId) {
    _useCase = useCase;
    _request = MessageQueryRequest(channelId: channelId);
  }

  /// includeDeleted
  MessageGetQueryBuilder includeDeleted(bool includeDeleted) {
    if (!includeDeleted) {
      _isDeleted = false;
    }
    return this;
  }

  /// Stack From End
  MessageGetQueryBuilder stackFromEnd(bool stackFromEnd) {
    _stackFromEnd = stackFromEnd;
    return this;
  }

  /// Parent ID
  MessageGetQueryBuilder parentId(String id) {
    _parentId = id;
    _isFilterByParentId = true;
    return this;
  }

  /// includingTags
  MessageGetQueryBuilder includingTags(AmityTags includingTags) {
    _includingTags = includingTags;
    return this;
  }

  /// excludingTags
  MessageGetQueryBuilder excludingTags(AmityTags excludingTags) {
    _excludingTags = excludingTags;
    return this;
  }

  /// getPagingData
  Future<PageListData<List<AmityMessage>, String>> getPagingData(
      {String? token, int? limit = 20}) async {
    if (_isDeleted != null) _request.isDeleted = _isDeleted;
    if (_includingTags != null) _request.tags = _includingTags!.tags;
    if (_excludingTags != null) _request.excludeTags = _excludingTags!.tags;
    if (_parentId != null) {
      _request.parentId = _parentId;
      _request.filterByParentId = _isFilterByParentId;
    }

    _request.options = OptionsRequest();

    if (token != null) {
      _request.options!.token = token;
    }

    if (limit != null) {
      // _request.options!.limit = limit;
      _request.options!.type = 'scrollable';
      if (!_stackFromEnd) {
        _request.options!.first = limit;
      } else {
        _request.options!.last = limit;
      }
    }

    final data = await _useCase.get(_request);

    return data;
  }

  /// Query
  Future<List<AmityMessage>> query({String? token, int? limit = 20}) async {
    if (_isDeleted != null) _request.isDeleted = _isDeleted;
    if (_includingTags != null) _request.tags = _includingTags!.tags;
    if (_excludingTags != null) _request.excludeTags = _excludingTags!.tags;
    if (_parentId != null) {
      _request.parentId = _parentId;
      _request.filterByParentId = _isFilterByParentId;
    }

    _request.options = OptionsRequest();

    if (token != null) {
      _request.options!.token = token;
    }

    if (limit != null) {
      _request.options!.limit = limit;
      if (!_stackFromEnd) {
        _request.options!.first = limit;
      } else {
        _request.options!.last = limit;
      }
    }

    final data = await _useCase.get(_request);

    return data.data;
  }
}
