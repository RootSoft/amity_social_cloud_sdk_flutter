import 'package:amity_sdk/src/core/core.dart';
import 'package:amity_sdk/src/domain/domain.dart';

/// Get Poll Use Case
class GetPollUseCase extends UseCase<AmityPoll, String> {
  /// Poll Repo
  final PollRepo pollRepo;

  /// Init Get Post Usecase
  GetPollUseCase({required this.pollRepo});
  @override
  Future<AmityPoll> get(String params) {
    return pollRepo.getPollByIdFromDb(params);
  }
}
