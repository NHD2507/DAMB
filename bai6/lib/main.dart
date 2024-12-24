import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý ghi chú',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? LoginScreen()
          : const PostsPage(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Password field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            // Loading spinner or Login button
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _signIn,
              child: const Text('Đăng nhập'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: const Text('Chưa có tài khoản? Đăng ký ngay'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PostsPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thất bại: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Password field
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            // Loading spinner or Register button
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _signUp,
              child: const Text('Đăng ký'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Đăng ký thất bại. Vui lòng thử lại sau.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email này đã được sử dụng.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Mật khẩu quá yếu. Vui lòng nhập mật khẩu mạnh hơn.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Địa chỉ email không hợp lệ.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký thất bại: $errorMessage'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final DatabaseReference _postsRef = FirebaseDatabase.instance
      .ref()
      .child('posts')
      .child(FirebaseAuth.instance.currentUser!.uid);

  void _addOrEditPost({String? key, Map? existingPost}) {
    String title = existingPost?['title'] ?? '';
    String content = existingPost?['content'] ?? '';
    String imageURL = existingPost?['imageURL'] ?? '';

    Future<void> _pickImage() async {
      // Logic to pick an image from `assets/images/`
      final imageNames = ['image1.png', 'image2.png', 'image3.png']; // Example
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            children: imageNames.map((imageName) {
              return ListTile(
                leading: Image.asset('assets/images/$imageName', width: 50, height: 50),
                title: Text(imageName),
                onTap: () {
                  setState(() {
                    imageURL = 'assets/images/$imageName';
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(existingPost == null ? 'Thêm bài viết mới' : 'Chỉnh sửa bài viết'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Tiêu đề'),
                      controller: TextEditingController(text: title),
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Nội dung'),
                      controller: TextEditingController(text: content),
                      onChanged: (value) {
                        content = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    imageURL.isNotEmpty
                        ? Image.asset(imageURL, height: 100, width: 100)
                        : const Text('Chưa chọn hình ảnh'),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Chọn hình ảnh'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (title.isNotEmpty && content.isNotEmpty && imageURL.isNotEmpty) {
                      if (key == null) {
                        _postsRef.push().set({
                          'title': title,
                          'content': content,
                          'imageURL': imageURL,
                        });
                      } else {
                        _postsRef.child(key).set({
                          'title': title,
                          'content': content,
                          'imageURL': imageURL,
                        });
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deletePost(String key) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa bài viết'),
          content: const Text('Bạn có chắc chắn muốn xóa bài viết này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                _postsRef.child(key).remove();
                Navigator.of(context).pop();
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý bài viết'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: FirebaseAnimatedList(
        query: _postsRef,
        itemBuilder: (context, snapshot, animation, index) {
          final key = snapshot.key;
          final post = snapshot.value as Map<dynamic, dynamic>?;
          final title = post?['title'] ?? 'Không có tiêu đề';
          final content = post?['content'] ?? 'Không có nội dung';

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: post?['imageURL'] != null
                  ? Image.asset(post!['imageURL'], width: 50, height: 50)
                  : const Icon(Icons.image),
              title: Text(title),
              subtitle: Text(content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _addOrEditPost(key: key, existingPost: post),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deletePost(key!),
                  ),
                ],
              ),
            ),
          );

        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditPost(),
        tooltip: 'Thêm bài viết mới',
        child: const Icon(Icons.add),
      ),
    );
  }
}
