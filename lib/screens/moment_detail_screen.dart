import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Innerlog/db/isar_service.dart';
import 'package:Innerlog/models/moment.dart';
import 'package:Innerlog/screens/add_moment_screen.dart';

class MomentDetailScreen extends StatelessWidget {
  final Moment moment;
  final IsarService service;

  const MomentDetailScreen({
    super.key,
    required this.moment,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMd().format(moment.date)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMomentScreen(
                    service: service,
                    moment: moment,
                  ),
                ),
              ).then((_) {
                // When returning from edit, we pop this screen as well
                // so the list can refresh. Alternatively, we could reload here.
                // For simplicity, let's pop back to home.
                Navigator.pop(context);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Moment'),
                  content: const Text('Are you sure you want to delete this moment?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await service.deleteMoment(moment.id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (moment.photoPath != null)
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.file(File(moment.photoPath!), fit: BoxFit.cover),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (moment.title.isNotEmpty) ...[
                    Text(
                      moment.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      const Text('Happiness Score: '),
                      ...List.generate(5, (index) {
                        return Icon(
                          index < moment.happinessScore
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    moment.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  if (moment.secretTags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      children: moment.secretTags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: Colors.deepPurple.shade50,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
