import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:tempus/components/app_update_available_dialog.dart';

class AppUpdateService {
  static AppUpdateService get to => Get.find();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<AppUpdateInfo?> checkForUpdate() async {
    await InAppUpdate.checkForUpdate().then((info) {
      return info;
    }).catchError((e) async {
      debugPrint(e.toString());
    });
    return null;
  }

}
