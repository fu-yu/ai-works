import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class AppColors {
  static const primary = Color(0xFF6200EE);
  static const secondary = Color(0xFF03DAC6);
  static const background = Color(0xFFF5F5F5);
  static const correct = Color(0xFF4CAF50);
  static const incorrect = Color(0xFFFF5252);
}

class Strings {
  static const appTitle = '韓国語クイズ';
  static const startQuiz = 'クイズを始める';
  static const nextQuestion = '次の問題';
  static const checkAnswer = '答えを確認';
  static const result = '結果';
  static const retry = 'もう一度';
  static const back = '戻る';
}

// 初級レベルのサンプルクイズデータ
final List<QuizSet> sampleQuizSets = [
  QuizSet(
    title: '基本的な挨拶',
    level: 1,
    quizzes: [
      Quiz(
        question: '「こんにちは」を韓国語で言うと？',
        correctAnswer: '안녕하세요',
        options: ['안녕하세요', '감사합니다', '안녕히 계세요', '미안합니다'],
        explanation: '「안녕하세요（アンニョンハセヨ）」は最も一般的な挨拶です。',
      ),
      Quiz(
        question: '「ありがとうございます」を韓国語で言うと？',
        correctAnswer: '감사합니다',
        options: ['감사합니다', '안녕하세요', '죄송합니다', '안녕히 가세요'],
        explanation: '「감사합니다（カムサハムニダ）」は「ありがとうございます」という意味です。',
      ),
    ],
  ),
];
