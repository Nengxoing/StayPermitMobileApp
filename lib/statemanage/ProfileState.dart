import 'package:get/get.dart';
import 'package:staypermitmobileapp/models/ProfileModel.dart';
import 'package:staypermitmobileapp/repository/Repository.dart';
import 'package:staypermitmobileapp/statemanage/app_verification_state.dart';

class ProfileState extends GetxController {
  Repository repository = Repository();
  AppVerificationState appVerificationState = Get.put(AppVerificationState());
  ProfileModel? profile;
  checkToken() async {}
}
