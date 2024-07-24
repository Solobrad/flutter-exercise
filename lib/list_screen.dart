import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListController _controller = Get.put(ListController());

    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.users.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else if (_controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error occurred. Please try again later.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _controller.fetchUsers(); // Retry fetching data
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        } else if (_controller.users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No data available.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _controller.fetchUsers(); // Retry fetching data
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_controller.isLoading.value &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                _controller.fetchUsers();
              }
              return true;
            },
            child: ListView.builder(
              itemCount: _controller.users.length +
                  (_controller.hasMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _controller.users.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final user = _controller.users[index];
                return ListTile(
                  title:
                      Text('${user['name']['first']} ${user['name']['last']}'),
                  subtitle: Text(
                    'DOB: ${user['dob']['date']}\nPhone: ${user['phone']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(user['gender']),
                  onTap: () {
                    // Handle tap event
                  },
                );
              },
            ),
          );
        }
      }),
    );
  }
}

class ListController extends GetxController {
  var users = <dynamic>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;
  var hasMore = true.obs; // To track if there are more items to load
  var page = 1.obs; // Start with page 1

  @override
  void onInit() {
    super.onInit();
    fetchUsers(); // Initial fetch
  }

  void fetchUsers() async {
    if (isLoading.value || !hasMore.value) return; // Prevent multiple loads

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
          hasMore.value = false; // No more items to load
        } else {
          users.addAll(fetchedUsers); // Add new items to existing list
          page.value++; // Increment page for next fetch
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
