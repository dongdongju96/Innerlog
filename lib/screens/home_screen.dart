import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:Innerlog/providers/moment_provider.dart';
import 'package:Innerlog/screens/add_moment_screen.dart';
import 'package:Innerlog/screens/moment_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final momentsAsyncValue = ref.watch(momentsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Innerlog')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search moments...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Happiness: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ...List.generate(5, (index) {
                  final score = index + 1;
                  final isSelected = ref.watch(happinessFilterProvider) == score;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text('$score'),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(happinessFilterProvider.notifier).state =
                            selected ? score : null;
                      },
                      selectedColor: _getHappinessColor(score).withOpacity(0.4),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: momentsAsyncValue.when(
              data: (moments) {
                if (moments.isEmpty) {
                  return const Center(
                      child: Text('No moments found matching your criteria.'));
                }
                return ListView.builder(
                  itemCount: moments.length,
                  itemBuilder: (context, index) {
                    final moment = moments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: moment.photoPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(moment.photoPath!),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(
                          moment.title.isNotEmpty
                              ? moment.title
                              : 'Untitled Moment',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              moment.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.yMMMd().add_jm().format(moment.date),
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          backgroundColor:
                              _getHappinessColor(moment.happinessScore),
                          radius: 12,
                          child: Text(
                            moment.happinessScore.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MomentDetailScreen(
                                moment: moment,
                                service: ref.read(isarServiceProvider),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Currently only Home is implemented
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddMomentScreen(service: ref.read(isarServiceProvider)),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddMomentScreen(service: ref.read(isarServiceProvider)),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getHappinessColor(int score) {
    switch (score) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow[700]!;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
