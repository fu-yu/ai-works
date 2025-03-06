# Korean Quiz App (韓国語クイズアプリ)

効率的な韓国語学習をサポートするインタラクティブなクイズアプリケーションです。

## 主な機能

- レベル別の韓国語クイズセット
- インタラクティブなクイズ体験
- 即時フィードバック
- 学習進捗の管理と可視化
- マルチ言語対応（日本語・英語）

## 技術スタック

- Flutter ^3.29.0
- Provider (状態管理)
- Freezed (データモデル)
- Flutter Secure Storage (セキュアなデータ保存)
- Shared Preferences (ローカルストレージ)
- Dio (HTTP通信)

## 開発要件

### Android開発環境
- Android SDK
- Android NDK 27.0.12077973
- Java 17（推奨、Java 8でも動作可）

## セットアップ

```bash
# 依存関係のインストール
flutter pub get

# コード生成の実行
flutter pub run build_runner build
```

### Gradle設定（Android）

`android/app/build.gradle.kts`で以下の設定が必要です：

```kotlin
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

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
```

## アプリケーションの実行

```bash
flutter run
```

## テスト

本プロジェクトは以下のテストを含みます：

```bash
# 単体テスト
flutter test

# 統合テスト
flutter test integration_test
```

## ライセンス

This project is licensed under the MIT License.
