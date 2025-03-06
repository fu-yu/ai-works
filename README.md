# AI Works Repository

このリポジトリには、AI関連の開発プロジェクトとその記録が含まれています。

## プロジェクト構成

### 1. korean_quiz_app/
韓国語学習支援のためのFlutterアプリケーション

- Flutter ^3.29.0を使用
- Java 17対応（開発環境）
- Android NDK 27.0.12077973
- マルチ言語対応（日本語・英語）

詳細は[korean_quiz_app/README.md](korean_quiz_app/README.md)を参照してください。

### 2. cline_docs/
プロジェクトのMemory Bank（開発記録）

- activeContext.md: 現在の作業コンテキスト
- progress.md: 進捗状況
- systemPatterns.md: システム設計パターン
- techContext.md: 技術的コンテキスト
- productContext.md: プロダクトコンテキスト

## 開発環境

- Flutter SDK（stable channel）
- Android Studio
- Visual Studio Code
- Java 17（推奨）

## セットアップ

```bash
# Korean Quiz Appの依存関係インストール
cd korean_quiz_app
flutter pub get
flutter pub run build_runner build

# アプリケーションの実行
flutter run
```

## ライセンス

This project is licensed under the MIT License.
