import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:wardy/core/constants/app_constants.dart';
import 'package:wardy/theme/app_theme.dart';

class AddClothingForm extends StatefulWidget {
  final XFile imageFile;
  final Function(String name, String category) onSave;
  final VoidCallback onCancel;

  const AddClothingForm({
    super.key,
    required this.imageFile,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<AddClothingForm> createState() => _AddClothingFormState();
}

class _AddClothingFormState extends State<AddClothingForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    // Default to the first category
    if (AppConstants.clothingCategories.isNotEmpty) {
      _selectedCategory = AppConstants.clothingCategories.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_nameController.text, _selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.largeRadius),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    'Add New Item',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: PhosphorIcon(PhosphorIcons.x()),
                    onPressed: widget.onCancel,
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Selected image preview
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.defaultRadius),
                child: Image.file(
                  File(widget.imageFile.path),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'Enter a name for this item',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Category selector
              Text(
                'Category',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      AppConstants.clothingCategories.map((category) {
                        final isSelected = category == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(
                              category,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : theme.colorScheme.onSurface,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            showCheckmark: false,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                  ),
                ),
                child: const Text('Save Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
