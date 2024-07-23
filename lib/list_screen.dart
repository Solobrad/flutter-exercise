import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ListController _controller = Get.put(ListController());

  @override
  void initState() {
    super.initState();
    _controller.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_controller.isError.value) {
          return Center(child: Text('Error occurred. Please try again later.'));
        } else if (_controller.users.isEmpty) {
          return Center(child: Text('No data available.'));
        } else {
          return ListView.builder(
            itemCount: _controller.users.length,
            itemBuilder: (context, index) {
              final user = _controller.users[index];
              return ListTile(
                title: Text('${user['name']['first']} ${user['name']['last']}'),
                subtitle: Text('DOB: ${user['dob']['date']}'),
                trailing: Text(user['gender']),
                onTap: () {
                  // Handle tap event
                },
              );
            },
          );
        }
      }),
    );
  }
}

class ListController extends GetxController {
  var users = <dynamic>[].obs;
  var isLoading = true.obs;
  var isError = false.obs;

  void fetchUsers() async {
    try {
      final response = await http
          .get(Uri.parse('https://randomuser.me/api/?results=50&seed=foo'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        users.value = data['results']; // Ensure 'results' is the correct key
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
