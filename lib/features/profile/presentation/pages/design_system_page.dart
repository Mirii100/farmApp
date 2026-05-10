import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../../../../core/constants/colors.dart';

class DesignSystemPage extends StatelessWidget {
  const DesignSystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design System')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Color Tokens'),
            const SizedBox(height: 12),
            _buildColorGrid(),
            const SizedBox(height: 24),
            _buildSectionTitle('Typography'),
            const SizedBox(height: 12),
            _buildTypographySection(context),
            const SizedBox(height: 24),
            _buildSectionTitle('Component Library'),
            const SizedBox(height: 12),
            _buildComponentLibrary(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryGreen,
        fontFamily: 'Fraunces',
      ),
    );
  }

  Widget _buildColorGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.8,
      children: [
        _buildColorItem('Primary', AppColors.primaryGreen, '#1A5C2A'),
        _buildColorItem('Secondary', AppColors.secondaryGreen, '#2D7A3A'),
        _buildColorItem('Surface', AppColors.greenSurface, '#E8F5E9'),
        _buildColorItem('Amber', AppColors.amberAlert, '#E65C00'),
        _buildColorItem('Info', AppColors.infoBlue, '#1565C0'),
        _buildColorItem('Danger', AppColors.dangerRed, '#C62828'),
      ],
    );
  }

  Widget _buildColorItem(String label, Color color, String hex) {
    return Column(
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        Text(hex, style: const TextStyle(fontSize: 10, color: AppColors.textTertiary, fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildTypographySection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fraunces — Headings',
              style: TextStyle(fontFamily: 'Fraunces', fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Plus Jakarta Sans — Body Bold',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Plus Jakarta Sans — Body Regular',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 4),
            const Text(
              'Plus Jakarta Sans — Small Label',
              style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentLibrary(BuildContext context) {
    return Column(
      children: [
        _buildComponentRow('Buttons', [
          ElevatedButton(onPressed: () {}, child: const Text('Primary')),
          OutlinedButton(onPressed: () {}, child: const Text('Secondary')),
        ]),
        _buildComponentRow('Icon Buttons', [
          IconButton(icon: const Icon(TablerIcons.plus), onPressed: () {}),
          IconButton(icon: const Icon(TablerIcons.microphone), onPressed: () {}, color: AppColors.primaryGreen),
        ]),
        _buildComponentRow('Tags', [
          _buildTag('Synced', AppColors.primaryGreen, AppColors.greenSurface),
          _buildTag('Queued', AppColors.amberAlert, AppColors.amberLight),
        ]),
      ],
    );
  }

  Widget _buildComponentRow(String label, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textTertiary)),
          const SizedBox(height: 8),
          Wrap(spacing: 12, children: children),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
