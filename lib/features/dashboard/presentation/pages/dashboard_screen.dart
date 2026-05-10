import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../../../core/constants/colors.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../records/presentation/pages/records_page.dart';
import '../../../finance/presentation/pages/finance_page.dart';
import '../../../reports/presentation/pages/reports_page.dart';
import '../../../ai/presentation/pages/ai_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const RecordsPage(),
    const FinancePage(),
    const ReportsPage(),
    const AiPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primaryGreen,
          unselectedItemColor: AppColors.textTertiary,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(TablerIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(TablerIcons.notes),
              label: 'Records',
            ),
            BottomNavigationBarItem(
              icon: Icon(TablerIcons.cash),
              label: 'Finance',
            ),
            BottomNavigationBarItem(
              icon: Icon(TablerIcons.chart_bar),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(TablerIcons.robot),
              label: 'AI',
            ),
          ],
        ),
      ),
    );
  }
}
