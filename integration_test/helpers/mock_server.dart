import 'dart:convert';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

class MockAuthServer {
  final Router _router = Router();

  MockAuthServer() {
    _router.post('/auth/login', (shelf.Request req) async {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      if (body['username'] == 'test' && body['password'] == 'pass') {
        return shelf.Response.ok(
          jsonEncode({
            'access_token': 'access-1',
            'refresh_token': 'refresh-1',
            'expires_in': 3600,
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return shelf.Response(401);
    });

    _router.post('/auth/refresh', (shelf.Request req) async {
      final body = jsonDecode(await req.readAsString()) as Map<String, dynamic>;
      final refresh = body['refreshToken'] ?? body['refresh_token'];
      if (refresh == 'refresh-1') {
        return shelf.Response.ok(
          jsonEncode({
            'access_token': 'access-2',
            'refresh_token': 'refresh-2',
            'expires_in': 3600,
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return shelf.Response(401);
    });

    _router.get('/me', (shelf.Request req) async {
      final auth = req.headers['authorization'];
      if (auth == 'Bearer access-2') {
        return shelf.Response.ok(
          jsonEncode({'id': 1, 'name': 'Test User'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return shelf.Response(401);
    });

    _router.get('/auth/me', (shelf.Request req) async {
      final auth = req.headers['authorization'];
      if (auth == 'Bearer access-2') {
        return shelf.Response.ok(
          jsonEncode({'id': 1, 'name': 'Test User'}),
          headers: {'Content-Type': 'application/json'},
        );
      }
      return shelf.Response(401);
    });
  }

  Router get router => _router;
}
