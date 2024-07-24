import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'notification_service.dart'; // Import your NotificationService

class ListController extends GetxController {
  var users = <dynamic>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var hasMore = true.obs;
  var page = 1.obs;

  final NotificationService notificationService =
      Get.find<NotificationService>();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(
            'https://randomuser.me/api/?results=20&seed=foo&page=${page.value}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> fetchedUsers = data['results'];

        if (fetchedUsers.isEmpty) {
          hasMore.value = false;
        } else {
          users.addAll(fetchedUsers);
          page.value++;

          // Schedule notifications based on DOB
          for (var user in fetchedUsers) {
            final dob = DateTime.parse(user['dob']['date']);
            final notificationTime = DateTime(dob.year, dob.month, dob.day, 8,
                0); // Schedule at 8 AM on the birthday
            notificationService.scheduleNotification(
              user['login']['uuid'].hashCode, // Unique ID for each notification
              'Happy Birthday ${user['name']['first']}!',
              'It\'s ${user['name']['first']}\'s birthday today!',
              notificationTime,
            );
          }
        }
      } else {
        isError.value = true;
      }
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
