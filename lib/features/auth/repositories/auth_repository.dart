import '../services/auth_service.dart';

class AuthRepository {
  final AuthService service;

  AuthRepository(this.service);

  register(data) => service.register(data);

  login(email, password) => service.login(email, password);

  logout() => service.logout();
}
