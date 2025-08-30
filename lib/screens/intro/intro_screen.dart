import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:times/data/user_settings_repository.dart';
import 'package:times/routes.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final List<Map<String, String>> _pages = [
    {
      'title': 'Bem-vindo ao App',
      'subtitle': 'Aqui você vai acompanhar tudo sobre o seu time favorito.',
      'lottie': 'assets/lottie/intro1.json',
    },
    {
      'title': 'Escolha seu Time',
      'subtitle':
          'Selecione seu clube do coração para personalizar a experiência.',
      'lottie': 'assets/lottie/intro2.json',
    },
    {
      'title': 'Torcida Conectada',
      'subtitle': 'Fique por dentro das novidades e compartilhe sua paixão!',
      'lottie': 'assets/lottie/intro3.json',
    },
  ];

  final userSettingsRepository = UserSettingsRepository();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _dontShowAgain = false;

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _finishIntro();
    }
  }

  Future<void> _finishIntro() async {
    await userSettingsRepository.setShowIntro(!_dontShowAgain);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.home);
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Lottie.asset(
                            page['lottie']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          page['title']!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          page['subtitle']!,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (isLastPage)
              Visibility(
                visible: isLastPage,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _dontShowAgain,
                        onChanged: (val) {
                          setState(() {
                            _dontShowAgain = val ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: Text('Não mostrar essa introdução novamente.'),
                      ),
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(onPressed: _onBack, child: Text('Voltar'))
                  else
                    SizedBox(width: 80),
                  TextButton(
                    onPressed: _onNext,
                    child: Text(isLastPage ? 'Concluir' : 'Avançar'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
