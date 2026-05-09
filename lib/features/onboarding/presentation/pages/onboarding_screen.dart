import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../../../core/constants/colors.dart';
import '../../dashboard/presentation/pages/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildStep1(),
                _buildStep2(),
                _buildStep3(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8,
                      width: _currentPage == index ? 20 : 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: _currentPage == index ? AppColors.primaryGreen : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_currentPage == 2 ? 'Get Started' : 'Continue'),
                        const SizedBox(width: 8),
                        const Icon(TablerIcons.arrow_right, size: 18),
                      ],
                    ),
                  ),
                ),
                if (_currentPage == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Already have an account? Sign in',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 48),
          decoration: const BoxDecoration(
            color: AppColors.primaryGreen,
          ),
          child: Column(
            children: [
              const Text('🌾', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(
                'Karibu ShambaBook',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Usimamizi wa shamba kwa simu yako',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Rekodi shamba lako, pata ushauri wa AI, fuatilia mapato — popote bila intaneti.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                _buildFeatureItem(
                  icon: TablerIcons.microphone,
                  title: 'Voice recording',
                  desc: 'Speak in Swahili, Kikuyu or Luo',
                  color: AppColors.primaryGreen,
                  bgColor: AppColors.greenSurface,
                ),
                const SizedBox(height: 10),
                _buildFeatureItem(
                  icon: TablerIcons.wifi_off,
                  title: 'Works offline',
                  desc: 'No internet needed to record',
                  color: AppColors.infoBlue,
                  bgColor: AppColors.infoLight,
                ),
                const SizedBox(height: 10),
                _buildFeatureItem(
                  icon: TablerIcons.device_mobile,
                  title: 'M-Pesa connected',
                  desc: 'Track payments automatically',
                  color: AppColors.amberAlert,
                  bgColor: AppColors.amberLight,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        _buildStepHeader('Step 2 of 4', 'Your language & region'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select your language',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.5,
                  children: [
                    _buildLanguageItem('Kiswahili', 'East Africa', true),
                    _buildLanguageItem('Kikuyu', 'Central Kenya', false),
                    _buildLanguageItem('Luo', 'Western Kenya', false),
                    _buildLanguageItem('Yoruba', 'Nigeria', false),
                    _buildLanguageItem('Hausa', 'North Nigeria', false),
                    _buildLanguageItem('English', 'All regions', false),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'County / Region',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(),
                  value: 'Kiambu County',
                  items: ['Kiambu County', 'Murang\'a County', 'Nakuru County']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (_) {},
                ),
                const SizedBox(height: 14),
                const Text(
                  'Currency',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(),
                  value: 'KES',
                  items: ['KES', 'UGX', 'TZS', 'NGN']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageItem(String title, String subtitle, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.greenSurface : Colors.white,
        border: Border.all(
          color: isSelected ? AppColors.primaryGreen : AppColors.border,
          width: isSelected ? 2 : 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        _buildStepHeader('Step 3 of 4', 'Tell us about your farm'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Farm name',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                const TextField(
                  decoration: InputDecoration(hintText: 'e.g. Waweru Farm'),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Total farm size',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'e.g. 2.5'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(),
                        value: 'Acres',
                        items: ['Acres', 'Hectares']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                            .toList(),
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'What do you farm? (select all)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildChip('Crops', true),
                    _buildChip('Livestock', true),
                    _buildChip('Poultry', false),
                    _buildChip('Fish', false),
                    _buildChip('Dairy', false),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Mobile money number',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                const TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(hintText: '+254 7xx xxx xxx'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.greenSurface : Colors.white,
        border: Border.all(
          color: isSelected ? AppColors.primaryGreen : AppColors.border,
          width: isSelected ? 2 : 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildStepHeader(String step, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.primaryGreen,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            step,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }
}
