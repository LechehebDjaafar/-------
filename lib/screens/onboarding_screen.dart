import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final AppLocalizations translations;

  const OnboardingScreen({super.key, required this.translations});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      image: Icons.map_outlined,
      title: 'خريطة تفاعلية',
      description: 'تتبع مواقع سلات المهملات في ولاية الشلف بسهولة',
      color: Colors.blue,
    ),
    OnboardingPage(
      image: Icons.delete_outline,
      title: 'إدارة ذكية',
      description: 'متابعة حالة السلات ونسبة امتلائها في الوقت الحقيقي',
      color: Colors.green,
    ),
    OnboardingPage(
      image: Icons.notifications_outlined,
      title: 'إشعارات فورية',
      description: 'تلقي تنبيهات عند امتلاء السلات',
      color: Colors.orange,
    ),
    OnboardingPage(
      image: Icons.analytics_outlined,
      title: 'نظام متكامل',
      description: 'حل متكامل لإدارة النفايات بطريقة ذكية وفعالة',
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _pages.asMap().entries.map((entry) {
                    return Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == entry.key
                            ? _pages[_currentPage].color
                            : Colors.grey.shade300,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage > 0)
                        TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('السابق'),
                        )
                      else
                        const SizedBox(width: 60),
                      if (_currentPage < _pages.length - 1)
                        TextButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('التالي'),
                        )
                      else
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/auth');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            backgroundColor: _pages[_currentPage].color,
                          ),
                          child: const Text('ابدأ الآن'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            page.color.withOpacity(0.2),
            page.color.withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.image,
            size: 150,
            color: page.color,
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData image;
  final String title;
  final String description;
  final Color color;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    required this.color,
  });
}
