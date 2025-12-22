import 'dart:async';
import 'dart:math';
import 'package:drivingschool/utils/driving_questions.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class DrivingMockTestPage extends StatefulWidget {
  const DrivingMockTestPage({super.key});

  @override
  State<DrivingMockTestPage> createState() => _DrivingMockTestPageState();
}

class _DrivingMockTestPageState extends State<DrivingMockTestPage>
    with TickerProviderStateMixin {
  Level _selectedLevel = Level.beginner;
  late List<Question> _questions;
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedOptionIndex;
  bool _showResult = false;
  bool _showExplanation = false;

  // Audio players
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadQuestionsForLevel();

    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    // Preload sounds
    _preloadSounds();
  }

  Future<void> _preloadSounds() async {
    try {
      await _audioPlayer.setSource(AssetSource('sounds/correct.mp3'));
      await _audioPlayer.setSource(AssetSource('sounds/wrong.mp3'));
      await _audioPlayer.setSource(AssetSource('sounds/page_turn.mp3'));
    } catch (e) {
      print('Error preloading sounds: $e');
    }
  }

  void _loadQuestionsForLevel() {
    // Get questions for selected level and shuffle them
    _questions = allQuestions.where((q) => q.level == _selectedLevel).toList()
      ..shuffle(_random);

    // Take only 10 questions per level for manageable test
    if (_questions.length > 10) {
      _questions = _questions.sublist(0, 10);
    }

    _currentIndex = 0;
    _score = 0;
    _isAnswered = false;
    _selectedOptionIndex = null;
    _showResult = false;
    _showExplanation = false;
  }

  Future<void> _playSound(String soundType) async {
    try {
      if (soundType == 'correct') {
        await _audioPlayer.play(AssetSource('sounds/correct.mp3'));
      } else if (soundType == 'wrong') {
        await _audioPlayer.play(AssetSource('sounds/wrong.mp3'));
      } else if (soundType == 'click') {
        await _audioPlayer.play(AssetSource('sounds/click.mp3'));
      }
    } catch (e) {
      // Try fallback sound
      try {
        await _audioPlayer.play(AssetSource('sounds/page_turn.mp3'));
      } catch (e2) {
        print('Error playing sound: $e2');
      }
    }
  }

  void _selectOption(int index) async {
    if (_isAnswered) return;

    await _playSound('click');
    _scaleController.forward();

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;

      final isCorrect = index == _questions[_currentIndex].correctIndex;

      if (isCorrect) {
        _score++;
        _playSound('correct');
        _pulseController.repeat(reverse: true);
      } else {
        _playSound('wrong');
        _shakeController.forward();
      }
    });

    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _showExplanation = true;
      _pulseController.stop();
    });
  }

  void _nextQuestion() async {
    await _playSound('click');
    _scaleController.reset();

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedOptionIndex = null;
        _showExplanation = false;
      });
    } else {
      setState(() {
        _showResult = true;
      });
    }
  }

  void _restartLevel() async {
    await _playSound('click');
    setState(() {
      _loadQuestionsForLevel();
    });
  }

  String _levelLabel(Level level) {
    switch (level) {
      case Level.beginner:
        return '🚦 Beginner';
      case Level.intermediate:
        return '🚗 Intermediate';
      case Level.advanced:
        return '🏎️ Advanced';
    }
  }

  Color _levelColor(Level level) {
    switch (level) {
      case Level.beginner:
        return const Color(0xFF6366F1); // Indigo
      case Level.intermediate:
        return const Color(0xFFF59E0B); // Amber
      case Level.advanced:
        return const Color(0xFFEF4444); // Red
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _scaleController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _showResult ? _buildResultView() : _buildQuizView(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    if (_questions.isEmpty) {
      return Center(
        child: Text(
          'No questions available for this level',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final Question currentQuestion = _questions[_currentIndex];
    final double progress = (_currentIndex + 1) / _questions.length;
    final Color primaryColor = _levelColor(_selectedLevel);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _levelLabel(_selectedLevel),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_score/${_questions.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Progress bar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Question card
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${_currentIndex + 1}',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentQuestion.question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Options
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: currentQuestion.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final String optionText = currentQuestion.options[index];
                    final bool isSelected = _selectedOptionIndex == index;
                    final bool isCorrect =
                        index == currentQuestion.correctIndex;

                    Color backgroundColor = Colors.white.withOpacity(0.05);
                    Color borderColor = Colors.white.withOpacity(0.1);
                    Color textColor = Colors.white;
                    Widget? trailingIcon;

                    if (_isAnswered) {
                      if (isCorrect) {
                        backgroundColor = const Color(
                          0xFF10B981,
                        ).withOpacity(0.2);
                        borderColor = const Color(0xFF10B981);
                        trailingIcon = Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF10B981),
                          size: 24,
                        );
                      } else if (isSelected) {
                        backgroundColor = const Color(
                          0xFFEF4444,
                        ).withOpacity(0.2);
                        borderColor = const Color(0xFFEF4444);
                        trailingIcon = Icon(
                          Icons.cancel_rounded,
                          color: const Color(0xFFEF4444),
                          size: 24,
                        );
                      }
                    } else if (isSelected) {
                      backgroundColor = primaryColor.withOpacity(0.2);
                      borderColor = primaryColor;
                    }

                    return GestureDetector(
                      onTap: () => _selectOption(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 2),
                          boxShadow: [
                            if (isSelected && _isAnswered)
                              BoxShadow(
                                color: borderColor.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primaryColor
                                    : Colors.white.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                optionText,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (trailingIcon != null) ...[
                              const SizedBox(width: 8),
                              trailingIcon,
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Explanation
                if (_showExplanation && _isAnswered)
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    offset: const Offset(0, -0.1),
                    child: Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color:
                            _selectedOptionIndex == currentQuestion.correctIndex
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              _selectedOptionIndex ==
                                  currentQuestion.correctIndex
                              ? const Color(0xFF10B981).withOpacity(0.3)
                              : const Color(0xFFEF4444).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            _selectedOptionIndex == currentQuestion.correctIndex
                                ? Icons.check_circle
                                : Icons.info,
                            color:
                                _selectedOptionIndex ==
                                    currentQuestion.correctIndex
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              currentQuestion.explanation,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),

        // Next button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isAnswered ? _nextQuestion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentIndex == _questions.length - 1
                      ? 'Finish Test'
                      : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _currentIndex == _questions.length - 1
                      ? Icons.flag
                      : Icons.arrow_forward_ios_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Level selector
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: Level.values.map((level) {
              final bool active = level == _selectedLevel;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedLevel = level;
                      _loadQuestionsForLevel();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: active
                        ? _levelColor(level)
                        : Colors.white.withOpacity(0.1),
                    foregroundColor: active
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_levelLabel(level)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    final int total = _questions.length;
    final double percent = (total == 0 ? 0 : _score / total) * 100;
    final Color primaryColor = _levelColor(_selectedLevel);

    String remark;
    IconData icon;
    Color remarkColor;

    if (percent >= 80) {
      remark = 'Excellent! 🎉 You are test ready!';
      icon = Icons.emoji_events;
      remarkColor = const Color(0xFF10B981);
    } else if (percent >= 60) {
      remark = 'Good! 👍 A bit more practice will help.';
      icon = Icons.thumb_up;
      remarkColor = const Color(0xFFF59E0B);
    } else {
      remark = 'Keep practicing! Review traffic rules carefully.';
      icon = Icons.lightbulb;
      remarkColor = const Color(0xFFEF4444);
    }

    return Column(
      children: [
        // Result card display
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Score circle
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.7)],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: CircularProgressIndicator(
                            value: percent / 100,
                            strokeWidth: 8,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$_score/$total',
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'CORRECT',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Percentage display
                  Text(
                    '${percent.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Remark section
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: remarkColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: remarkColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, color: remarkColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          remark,
                          style: TextStyle(
                            color: remarkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Action buttons
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _restartLevel,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Retry Level',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final int idx = Level.values.indexOf(_selectedLevel);
              setState(() {
                if (idx < Level.values.length - 1) {
                  _selectedLevel = Level.values[idx + 1];
                } else {
                  _selectedLevel = Level.beginner;
                }
                _loadQuestionsForLevel();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.1),
              foregroundColor: Colors.white.withOpacity(0.9),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Next Level',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
