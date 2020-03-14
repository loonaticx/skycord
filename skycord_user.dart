import 'package:hive/hive.dart';
import 'package:skyscrapeapi/data_types.dart';
import 'package:skyscrapeapi/sky_core.dart';

import 'extensions.dart';

//part 'skycord_user.g.dart';

@HiveType()
class SkycordUser extends HiveObject {
  @HiveField(0)
  String discordId;

  @HiveField(1)
  String skywardUrl;

  @HiveField(2)
  String username;

  @HiveField(3)
  String password;

  @HiveField(4)
  bool isSubscribed = false;

  User skywardUser;

  List<Assignment> previousEmptyAssignments = List();

  Future<User> getSkywardUser() async {
    return skywardUser ??= await SkyCore.login(username, password, skywardUrl);
  }

  Future<List<Assignment>> getNewAssignments() async {
    final skywardUser = await getSkywardUser();
    final gradebook = await skywardUser.getGradebook();
    final emptyAssignments = gradebook.quickAssignments
        .where((assignment) => assignment.isNotGraded())
        .toList();

    final newAssignments = previousEmptyAssignments
        .where((assignment) => !emptyAssignments.contains(assignment))
        .toList();
    previousEmptyAssignments = emptyAssignments;
    return newAssignments;
  }
}
