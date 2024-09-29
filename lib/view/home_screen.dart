import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posts_app/controller/post_controller.dart';

class PostListScreen extends StatelessWidget {
  final PostController _postController = Get.put(PostController());

  PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 202, 68, 255),
        title: Obx(() => Center(
                child: Text(
              _postController.isOffline.value ? 'Posts (Offline)' : 'Posts',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24),
            ))),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () =>
             _postController.fetchPosts(),
          )
        ],
      ),
      body: Obx(() {
        if (_postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (_postController.posts.isEmpty) {
          return const Center(child: Text('No posts available.'));
        } else {
          return ListView.builder(
            itemCount: _postController.posts.length,
            itemBuilder: (context, index) {
              var post = _postController.posts[index];
              return Container(
                //padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(7),
                height: 225,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ListTile(
                  title: Text(
                    post.title ?? 'No Title',
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(post.body ?? 'No Body',
                      style: const TextStyle(color: Colors.white)),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
