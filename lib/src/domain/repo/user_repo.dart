import 'package:amity_sdk/src/core/core.dart';
import 'package:amity_sdk/src/core/model/api_request/update_user_request.dart';
import 'package:amity_sdk/src/domain/domain.dart';

abstract class UserRepo {
  Future<AmityUser> getUserById(String userId);
  Future<AmityUser> getUserByIdFromDb(String userId);
  Future<List<AmityUser>> getUsers(UsersRequest request);
  List<String> getPermissions(String userId);
  Future<List<AmityUser>> updateUser(UpdateUserRequest request);
}