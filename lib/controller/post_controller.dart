import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:posts_app/database/database_helper.dart';
import 'package:posts_app/models/post.dart';

class PostController extends GetxController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  var url = Uri.parse("https://jsonplaceholder.typicode.com/posts");
  var posts = <Post>[].obs;
  var isLoading = true.obs;
  var isOffline = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, fetch posts from the database
      print("No internet connection. Loading data from local database.");
      isOffline(true);
      await fetchPostsFromDatabase();
    } else {
      // Internet connection is available, fetch posts from API
      print("Internet connection available. Loading data from API.");
      isOffline(false);
      await fetchPostsFromApi();
    }
    isLoading(false);
  }

  Future<void> fetchPostsFromApi() async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<Post> fetchedPosts =
            jsonData.map((json) => Post.fromJson(json)).toList();

        posts.assignAll(fetchedPosts);

        await _dbHelper.clearAllPosts();
        for (var post in fetchedPosts) {
          await _dbHelper.insertPost(post);
        }
      } else {
        throw Exception('Failed to load posts from API');
      }
    } catch (e) {
      isLoading(false);
      print("Error fetching posts from API: $e");
      await fetchPostsFromDatabase();
    }
  }

  Future<void> fetchPostsFromDatabase() async {
    try {
      List<Post> localPosts = await _dbHelper.getAllPosts();
      if (localPosts.isEmpty) {
        print("No posts available in local database");
      }
      posts.assignAll(localPosts);
    } catch (e) {
      isLoading(false);
      print("Error fetching posts from database: $e");
    }
  }
}
