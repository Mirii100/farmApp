import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:shambabook/core/constants/colors.dart';
import '../providers/finance_provider.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Management'),
        actions: [
          IconButton(icon: const Icon(TablerIcons.history), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer<FinanceProvider>(
          builder: (context, provider, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfitLossCard(provider),
              const SizedBox(height: 24),
              _buildSectionTitle('Smart Analytics'),
              const SizedBox(height: 12),
              _buildAnalyticsCharts(context),
              const SizedBox(height: 20),
              _buildYieldTrendCard(context),
              const SizedBox(height: 24),
              _buildSectionTitle('Mobile Money Integration'),
              const SizedBox(height: 12),
              _buildMpesaCard(),
              const SizedBox(height: 24),
              _buildSectionTitle('Recent Transactions'),
              const SizedBox(height: 12),
              _buildTransactionList(provider),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionDialog(context),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(TablerIcons.plus, color: Colors.white),
        label: const Text('Add Transaction', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool isIncome = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('New Transaction', style: TextStyle(fontFamily: 'Fraunces')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Income'),
                      selected: isIncome,
                      onSelected: (val) => setDialogState(() => isIncome = true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Expense'),
                      selected: !isIncome,
                      onSelected: (val) => setDialogState(() => isIncome = false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: titleController, decoration: const InputDecoration(hintText: 'Description (e.g. Sale of Milk)')),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Amount (KSh)', prefixText: 'KSh '),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                  context.read<FinanceProvider>().addTransaction(Transaction(
                        title: titleController.text,
                        amount: 'KSh ${amountController.text}',
                        date: 'Today',
                        isIncome: isIncome,
                      ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Record'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    );
  }

  Widget _buildProfitLossCard(FinanceProvider provider) {
    return Card(
      color: AppColors.primaryGreen,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Net Profit — Season A 2026', style: TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              provider.netProfit,
              style: const TextStyle(fontFamily: 'Fraunces', fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPLStat('Income', provider.totalIncome, Colors.greenAccent),
                Container(width: 1, height: 30, color: Colors.white24),
                _buildPLStat('Expenses', provider.totalExpenses, Colors.orangeAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPLStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildAnalyticsCharts(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Expense Breakdown', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(value: 45, color: AppColors.primaryGreen, radius: 40, showTitle: false),
                    PieChartSectionData(value: 30, color: AppColors.infoBlue, radius: 40, showTitle: false),
                    PieChartSectionData(value: 15, color: AppColors.amberAlert, radius: 40, showTitle: false),
                    PieChartSectionData(value: 10, color: AppColors.textTertiary, radius: 40, showTitle: false),
                  ],
                  centerSpaceRadius: 30,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildYieldTrendCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Yield Trend (Tons/Season)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            SizedBox(
              height: 120,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1.2),
                        FlSpot(1, 1.8),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2.2),
                        FlSpot(4, 2.8),
                      ],
                      isCurved: true,
                      color: AppColors.primaryGreen,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: true, color: AppColors.primaryGreen.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Seeds', AppColors.primaryGreen),
        const SizedBox(width: 12),
        _buildLegendItem('Labor', AppColors.infoBlue),
        const SizedBox(width: 12),
        _buildLegendItem('Transport', AppColors.amberAlert),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildMpesaCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.greenLight, borderRadius: BorderRadius.circular(10)),
              child: const Icon(TablerIcons.device_mobile, color: AppColors.primaryGreen, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('M-Pesa Connected', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Text('Automatic transaction tracking active', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Manage', style: TextStyle(color: AppColors.primaryGreen, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(FinanceProvider provider) {
    return Column(
      children: provider.transactions
          .map((t) => _buildTransactionItem(t.title, t.amount, t.date, t.isIncome))
          .toList(),
    );
  }

  Widget _buildTransactionItem(String title, String amount, String date, bool isIncome) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5))),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Text(date, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green : AppColors.dangerRed,
            ),
          ),
        ],
      ),
    );
  }
}
