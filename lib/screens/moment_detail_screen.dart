import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Innerlog/models/moment.dart';

class MomentDetailScreen extends StatelessWidget {
  final Moment moment;

  const MomentDetailScreen({super.key, required this.moment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(DateFormat.yMMMd().format(moment.date))),
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
