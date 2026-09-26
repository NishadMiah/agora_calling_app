import 'package:flutter_project_architecture/common/widgets/toast_message.dart';
import 'package:get/get.dart';
import '../../core/app_routes/app_routes.dart';
import '../local_storage/shared_prefs.dart';
import '../../utils/app_const.dart';

class ApiChecker {
  static void checkApi(Response response, {bool getXSnackBar = false}) async {
    if (response.statusCode == 401) {
      await SharePrefsHelper.remove(AppConstants.bearerToken);
      Get.offAllNamed(AppRoutes.homeScreen);
    } else {
      showCustomSnackBar(response.body['error']);
    }
  }
}
