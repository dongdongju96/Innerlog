import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:Innerlog/db/isar_service.dart';
import 'package:Innerlog/models/moment.dart';

class AddMomentScreen extends StatefulWidget {
  final IsarService service;
  const AddMomentScreen({super.key, required this.service});

  @override
  State<AddMomentScreen> createState() => _AddMomentScreenState();
}

class _AddMomentScreenState extends State<AddMomentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  double _happinessScore = 3.0;
  String? _photoPath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Save image to local directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(image.path);
      final String localPath = path.join(appDir.path, fileName);
      await image.saveTo(localPath);

      setState(() {
        _photoPath = localPath;
      });
    }
  }

  void _saveMoment() async {
    if (_formKey.currentState!.validate()) {
      final moment = Moment()
        ..title = _titleController.text
        ..content = _contentController.text
        ..happinessScore = _happinessScore.toInt()
        ..secretTags = _tagsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList()
        ..photoPath = _photoPath
        ..date = DateTime.now();

      await widget.service.saveMoment(moment);

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Moment'),
        actions: [
          IconButton(onPressed: _saveMoment, icon: const Icon(Icons.check)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _photoPath != null
                        ? DecorationImage(
                            image: FileImage(File(_photoPath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _photoPath == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'What happened?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text('Happiness Score'),
              Slider(
                value: _happinessScore,
                min: 1,
                max: 5,
                divisions: 4,
                label: _happinessScore.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _happinessScore = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Secret Tags (comma separated)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
