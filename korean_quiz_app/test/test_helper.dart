import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:korean_quiz_app/repositories/score_repository.dart';

// カスタムモッククラスを作成して、必要なメソッドのみをオーバーライド
abstract class CustomFlutterSecureStorage extends FlutterSecureStorage {
  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  });

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  });

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  });

  @override
  Future<Map<String, String>> readAll({
    AndroidOptions? aOptions,
    IOSOptions? iOptions,
    LinuxOptions? lOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
  });
}

@GenerateNiceMocks([
  MockSpec<CustomFlutterSecureStorage>(as: #MockFlutterSecureStorage),
  MockSpec<IScoreRepository>(as: #MockIScoreRepository),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
}
