import 'dart:convert';
import '../models/post.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.papacapim.just.pro.br';

  String? token;

  Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',

      if (token != null) 'x-session-token': token!,
    };
  }

  Future<bool> login(String login, String password) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/sessions'),

      headers: {'Content-Type': 'application/json'},

      body: jsonEncode({'login': login, 'password': password}),
    );

    print('STATUS LOGIN: ${resposta.statusCode}');
    print('BODY LOGIN: ${resposta.body}');

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);

      print('DADOS LOGIN: $dados');

      if (dados['token'] == null) {
        print('ERRO: token não encontrado.');
        return false;
      }

      token = dados['token'];

      print('LOGIN REALIZADO COM SUCESSO');

      return true;
    }

    print('LOGIN FALHOU');
    return false;
  }

  Future<http.Response> createUser({
    required String login,
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': login,
        'name': name,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );
  }

  Future<List<Post>> getPosts() async {
    final resposta = await http.get(
      Uri.parse('$baseUrl/posts'),
      headers: headers,
    );

    print('STATUS POSTS: ${resposta.statusCode}');
    print('BODY POSTS: ${resposta.body}');

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao carregar posts: ${resposta.statusCode}');
    }

    final List<dynamic> dados = jsonDecode(resposta.body);

    return dados.map((json) => Post.fromJson(json)).toList();
  }

  Future<http.Response> createPost(String message) async {
    return await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: headers,
      body: jsonEncode({
        'post': {'message': message},
      }),
    );
  }

  Future<http.Response> deletePost(int postId) async {
    return await http.delete(
      Uri.parse('$baseUrl/posts/$postId'),
      headers: headers,
    );
  }

  Future<http.Response> likePost(int postId) async {
    return await http.post(
      Uri.parse('$baseUrl/posts/$postId/likes'),
      headers: headers,
    );
  }

  Future<http.Response> unlikePost(int postId) async {
    return await http.delete(
      Uri.parse('$baseUrl/posts/$postId/likes/me'),
      headers: headers,
    );
  }

  Future<http.Response> getReplies(int postId) async {
    return await http.get(
      Uri.parse('$baseUrl/posts/$postId/replies'),
      headers: headers,
    );
  }

  Future<http.Response> createReply(int postId, String message) async {
    return await http.post(
      Uri.parse('$baseUrl/posts/$postId/replies'),
      headers: headers,
      body: jsonEncode({
        'reply': {'message': message},
      }),
    );
  }

  Future<http.Response> getMe() async {
    return await http.get(Uri.parse('$baseUrl/users/me'), headers: headers);
  }

  Future<http.Response> getUser(String login) async {
    return await http.get(Uri.parse('$baseUrl/users/$login'), headers: headers);
  }

  Future<http.Response> searchUsers(String search) async {
    final uri = Uri.parse(
      '$baseUrl/users',
    ).replace(queryParameters: {'search': search});

    return await http.get(uri, headers: headers);
  }

Future<http.Response> searchPosts(String search) async {
  final uri = Uri.parse(
    '$baseUrl/posts',
  ).replace(queryParameters: {'search': search});

  return await http.get(uri, headers: headers);
}


  Future<http.Response> updateMe({
    String? login,
    String? name,
    String? password,
    String? passwordConfirmation,
    String? imageData,
  }) async {
    final user = <String, dynamic>{};

    if (login != null) user['login'] = login;
    if (name != null) user['name'] = name;
    if (password != null) user['password'] = password;
    if (passwordConfirmation != null) {
      user['password_confirmation'] = passwordConfirmation;
    }
    if (imageData != null) {
      user['image_data'] = imageData;
    }

    return await http.patch(
      Uri.parse('$baseUrl/users/me'),
      headers: headers,
      body: jsonEncode({'user': user}),
    );
  }

  Future<http.Response> followUser(String login) async {
    return await http.post(
      Uri.parse('$baseUrl/users/$login/followers'),
      headers: headers,
    );
  }

  Future<http.Response> unfollowUser(String login) async {
    return await http.delete(
      Uri.parse('$baseUrl/users/$login/followers/me'),
      headers: headers,
    );
  }

  Future<http.Response> deleteMe() async {
  print('TOKEN PARA EXCLUSÃO: $token');
  print('HEADERS PARA EXCLUSÃO: $headers');

  final resposta = await http.delete(
    Uri.parse('$baseUrl/users/me'),
    headers: headers,
  );

  print('STATUS DELETE USUÁRIO: ${resposta.statusCode}');
  print('BODY DELETE USUÁRIO: ${resposta.body}');

  return resposta;
}
}

final apiService = ApiService();
