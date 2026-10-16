import 'package:flutter/material.dart';
import '../data/models.dart';
import '../services/store.dart';

const budgetCategories = <(String, IconData)>[
  ('যাতায়াত', Icons.directions_car),
  ('খাবার', Icons.restaurant),
  ('থাকা', Icons.hotel),
  ('কেনাকাটা', Icons.shopping_bag),
  ('অন্যান্য', Icons.more_horiz),
];

IconData _iconFor(String c) =>
    budgetCategories.firstWhere((e) => e.$1 == c, orElse: () => budgetCategories.last).$2;

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  Future<void> _add(BuildContext context) async {
    final title = TextEditingController();
    final amount = TextEditingController();
    var cat = budgetCategories.first.$1;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('নতুন খরচ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: title, decoration: const InputDecoration(labelText: 'বিবরণ (যেমন: টোটো ভাড়া)')),
            const SizedBox(height: 10),
            TextField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'টাকা', prefixText: '₹ '),
            ),
            const SizedBox(height: 10),
            Wrap(spacing: 6, children: [
              for (final c in budgetCategories)
                ChoiceChip(
                  avatar: Icon(c.$2, size: 16),
                  label: Text(c.$1),
                  selected: cat == c.$1,
                  onSelected: (_) => setSheet(() => cat = c.$1),
                ),
            ]),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final a = double.tryParse(amount.text.trim());
                  if (a == null || a <= 0) return;
                  store.addBudget(BudgetItem(
                    DateTime.now().microsecondsSinceEpoch.toString(),
                    title.text.trim().isEmpty ? cat : title.text.trim(),
                    a,
                    cat,
                  ));
                  Navigator.pop(ctx);
                },
                child: const Text('যোগ করুন'),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final total = store.budgetTotal;
        final perPerson = total / store.people;
        final byCat = <String, double>{};
        for (final b in store.budget) {
          byCat[b.category] = (byCat[b.category] ?? 0) + b.amount;
        }
        return Scaffold(
          appBar: AppBar(title: const Text('ট্যুর বাজেট')),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _add(context),
            icon: const Icon(Icons.add),
            label: const Text('খরচ যোগ'),
          ),
          body: ListView(padding: const EdgeInsets.fromLTRB(12, 12, 12, 90), children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xff1b5e20), Color(0xff43a047)]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('মোট খরচ', style: TextStyle(color: Colors.white70)),
                Text('₹ ${total.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(children: [
                  Text('জনপ্রতি ₹ ${perPerson.toStringAsFixed(0)}',
                      style: const TextStyle(color: Color(0xffffeb3b), fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => store.setPeople(store.people - 1),
                    icon: const Icon(Icons.remove_circle, color: Colors.white),
                  ),
                  Text('${bn(store.people)} জন', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => store.setPeople(store.people + 1),
                    icon: const Icon(Icons.add_circle, color: Colors.white),
                  ),
                ]),
              ]),
            ),
            if (byCat.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final e in byCat.entries)
                  Chip(avatar: Icon(_iconFor(e.key), size: 16), label: Text('${e.key}: ₹${e.value.toStringAsFixed(0)}')),
              ]),
            ],
            const SizedBox(height: 12),
            if (store.budget.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Text('এখনো কোনো খরচ যোগ হয়নি।\nনিচের বোতামে চাপ দিয়ে যোগ করুন।', textAlign: TextAlign.center),
              ),
            for (final b in store.budget.reversed)
              Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Icon(_iconFor(b.category))),
                  title: Text(b.title),
                  subtitle: Text(b.category),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('₹${b.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => store.removeBudget(b.id),
                    ),
                  ]),
                ),
              ),
          ]),
        );
      },
    );
  }
}
