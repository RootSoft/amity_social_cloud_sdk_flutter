import 'package:amity_sdk/src/core/model/api_request/channel/get_channel_member_request.dart';
import 'package:amity_sdk/src/core/model/api_request/channel/update_channel_member_request.dart';
import 'package:amity_sdk/src/core/model/api_request/channel/update_channel_role_request.dart';
import 'package:amity_sdk/src/core/utils/page_list_data.dart';
import 'package:amity_sdk/src/data/data.dart';
import 'package:amity_sdk/src/domain/domain.dart';

/// [ChannelMemberRepoImpl]
class ChannelMemberRepoImpl extends ChannelMemberRepo {
  /// Channel Member Api Interface
  final ChannelMemberApiInterface channelMemberApiInterface;

  ///Db Adapter
  final DbAdapterRepo commonDbAdapter;

  /// init [ChannelMemberRepoImpl]
  ChannelMemberRepoImpl({
    required this.channelMemberApiInterface,
    required this.commonDbAdapter,
  });

  @override
  Future<List<AmityChannelMember>> addMember(
      UpdateChannelMembersRequest request) async {
    final data = await channelMemberApiInterface.addMember(request);
    final amityChannelMember =
        await data.saveToDb<AmityChannelMember>(commonDbAdapter);
    return amityChannelMember
        .where((element) => request.userIds!.contains(element.userId))
        .toList();
  }

  @override
  Future addRole(UpdateChannelRoleRequest request) async {
    final data = await channelMemberApiInterface.addRole(request);
    final amityChannel = await data.saveToDb<AmityChannel>(commonDbAdapter);
    return amityChannel.first;
  }

  @override
  Future<AmityChannelMember> getMember(String id, String userId) async {
    final data =
        commonDbAdapter.channelUserDbAdapter.getEntity('${id}_$userId');
    // final amityChannel = await data.saveToDb(commonDbAdapter);
    return data?.convertToAmityChannelMember() ?? AmityChannelMember()
      ..channelId = id
      ..userId = userId;
  }

  @override
  List<String>? getMemberPermission(String id, String userId) {
    final data =
        commonDbAdapter.channelUserDbAdapter.getEntity('${id}_$userId');
    return data!.permissions;
  }

  @override
  Future<AmityChannel> joinChannel(String id) async {
    final data = await channelMemberApiInterface.joinChannel(id);
    final amityChannel = await data.saveToDb<AmityChannel>(commonDbAdapter);
    return amityChannel.first;
  }

  @override
  Future leaveChannel(String id) async {
    final data = await channelMemberApiInterface.leaveChannel(id);
    final amityChannel = await data.saveToDb<AmityChannel>(commonDbAdapter);
    return amityChannel.first;
  }

  @override
  Future<PageListData<List<AmityChannelMember>, String>> queryMembers(
      GetChannelMembersRequest request) async {
    final data = await channelMemberApiInterface.getChannelMembers(request);

    //Save members sequence in to feed db
    // await communityMemberPagingDbAdapter.updateCommunityMemmberCollection(
    //     data.convertToCommunityMemberPagingHiveEntity());

    final amityChannelMember =
        await data.saveToDb<AmityChannelMember>(commonDbAdapter);
    return PageListData(amityChannelMember, data.paging!.next ?? '');
  }

  @override
  Future removeMember(UpdateChannelMembersRequest request) async {
    final data = await channelMemberApiInterface.removeMember(request);
    final amityChannel = await data.saveToDb<AmityChannel>(commonDbAdapter);
    return amityChannel.first;
  }

  @override
  Future removeRole(UpdateChannelRoleRequest request) async {
    final data = await channelMemberApiInterface.removeRole(request);
    final amityChannel = await data.saveToDb<AmityChannel>(commonDbAdapter);
    return amityChannel.first;
  }

  @override
  Future banMember(UpdateChannelMembersRequest request) async {
    final data = await channelMemberApiInterface.banMember(request);
    final amityChannel = await data.saveToDb<AmityChannel>(commonDbAdapter);
    return amityChannel.first;
  }

  @override
  Future unbanMember(UpdateChannelMembersRequest request) async {
    final data = await channelMemberApiInterface.unbanMember(request);
    final amityChannel = await data.saveToDb<AmityChannel>(commonDbAdapter);
    return amityChannel.first;
  }

  @override
  Future muteMember(UpdateChannelMembersRequest request) async {
    await channelMemberApiInterface.muteMember(request);

    if (request.userIds != null) {
      for (String userId in request.userIds!) {
        final channelMember = commonDbAdapter.channelUserDbAdapter
            .getEntity('${request.channelId}_$userId');
        if (channelMember != null) {
          if (request.mutePeriod! > 0) {
            channelMember.isMuted = true;
          } else if (request.mutePeriod! == 0) {
            channelMember.isMuted = false;
          }
          await channelMember.save();
        }
      }
    }
    return;
  }
}