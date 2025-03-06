# 技術コンテキスト

## 開発環境
1. フレームワーク
   - Flutter SDK（stable channel）
   - Dart 3.0.0以上
   - Android SDK

2. IDE/ツール
   - Visual Studio Code
   - Flutter & Dart プラグイン
   - Android Studio（エミュレータ用）

## 主要パッケージ
1. 状態管理
   ```yaml
   provider: ^6.1.1  # 状態管理
   ```

2. ストレージ
   ```yaml
   flutter_secure_storage: ^9.2.4  # セキュアストレージ
   shared_preferences: ^2.2.2  # ローカルストレージ
   ```

3. コード生成
   ```yaml
   freezed: ^2.0.0   # イミュータブルクラス
   json_serializable: ^6.0.0  # JSONシリアライズ
   build_runner: ^2.0.0  # コード生成
   ```

3. ローカライゼーション
   ```yaml
   flutter_localizations:
     sdk: flutter
   ```

## 技術的制約

1. プラットフォーム制限
   ```yaml
   platform:
     target: "android"
     exclude:
       - "ios"
       - "web"
       - "windows"
       - "macos"
       - "linux"
   ```

2. パフォーマンス要件
   - アプリサイズ: 50MB以下
   - 起動時間: 3秒以内
   - メモリ使用: 200MB以下
   - フレームレート: 60fps維持

3. コード品質基準
   - テストカバレッジ: 85%以上
   - 静的解析: strict mode
   - ドキュメンテーション: 必須
   - コーディング規約:
     - superパラメーターの使用
     - 非推奨APIの排除
     - 未使用インポートの除去
     - パフォーマンス最適化（不要な処理の削除）

## セキュリティ要件
1. データ保護
   - ローカルストレージの暗号化
   - センシティブデータの安全な取り扱い

2. プライバシー
   - 個人情報の最小限の収集
   - データ収集の透明性確保

## 開発プラクティス
1. バージョン管理
   - Git flow モデル
   - Semantic Versioning

2. コードレビュー
   - PRベースの開発
   - 静的解析チェック
   - テスト自動化

3. CI/CD
   - テスト自動実行
   - ビルド自動化
   - 静的解析チェック

## 開発環境セットアップ
1. エミュレータ設定
   - Pixel 9 API 35（推奨）
   - Android NDK 27.0.12077973（必須）
   - OpenGLESの警告は無視可能

2. Gradle設定
```gradle
# build.gradle.kts
android {
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
}
```

3. 基本セットアップ
```bash
# Flutter SDKのインストール
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

# 依存関係のインストール
flutter pub get

# コード生成
flutter pub run build_runner build

# テスト実行
flutter test

# アプリ実行
flutter run
