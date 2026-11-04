import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/dashed_border.dart';
import '../../../../core/widgets/map_placeholder.dart';
import '../../../../core/widgets/primary_button.dart';

const _photoTileWidth = 106.0;
const _photoTileHeight = 104.0;

class PickupDetailsScreen extends StatefulWidget {
  const PickupDetailsScreen({super.key});

  @override
  State<PickupDetailsScreen> createState() => _PickupDetailsScreenState();
}

class _PickupDetailsScreenState extends State<PickupDetailsScreen> {
  final _landmark = TextEditingController();
  final _notes = TextEditingController();
  Uint8List? _photo;

  @override
  void dispose() {
    _landmark.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (mounted) setState(() => _photo = bytes);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the photo library.')),
        );
      }
    }
  }

  void _save() {
    // TODO: send landmark, notes and photo with the booking once the API exists.
    context.push(AppRoutes.pickupSpot);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  const Text(
                    'Pickup Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: const SizedBox(
                        height: 162,
                        width: double.infinity,
                        child: MapPlaceholder(
                          pins: [
                            MapPin('Castle Restaurant', 0.12, 0.3),
                            MapPin('Abees Mess', 0.56, 0.62),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const _LocationCard(),
                    const SizedBox(height: 24),
                    const _FieldLabel('Landmark (Optional)'),
                    _OptionalField(
                      fieldKey: const Key('landmark_field'),
                      controller: _landmark,
                      hint: 'e.g. Near Metro Station, Gate 2',
                    ),
                    const SizedBox(height: 22),
                    const _FieldLabel('Additional Notes (Optional)'),
                    _OptionalField(
                      fieldKey: const Key('notes_field'),
                      controller: _notes,
                      hint: "e.g. I'll be at the main gate",
                    ),
                    const SizedBox(height: 22),
                    const _FieldLabel('Add Photo (Optional)'),
                    Row(
                      children: [
                        _AddPhotoTile(onTap: _pickPhoto),
                        const SizedBox(width: 12),
                        _PhotoSlot(
                          bytes: _photo,
                          onRemove: () => setState(() => _photo = null),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.sm,
                AppSpacing.screenPadding,
                AppSpacing.screenPadding,
              ),
              child: PrimaryButton(
                label: 'Save Pickup Details',
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD7D7D7)),
            ),
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR LOCATION',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.6,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Your Current Location',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    ),
  );
}

class _OptionalField extends StatelessWidget {
  const _OptionalField({
    required this.fieldKey,
    required this.controller,
    required this.hint,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE6E8EB)),
    );
    return TextField(
      key: fieldKey,
      controller: controller,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 11, color: Color(0xFFA3A9B0)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 38,
          vertical: 20,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.forest),
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('add_pickup_photo'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DashedBorder(
        child: Container(
          width: _photoTileWidth,
          height: _photoTileHeight,
          decoration: BoxDecoration(
            color: const Color(0xFFFAFBFA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_camera_outlined, size: 20),
              SizedBox(height: 8),
              Text('Add Photo', style: TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Preview slot shown beside "Add Photo"; the red button clears the photo.
class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({required this.bytes, required this.onRemove});

  final Uint8List? bytes;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: _photoTileWidth,
          height: _photoTileHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6E8EB)),
          ),
          child: bytes == null ? null : Image.memory(bytes!, fit: BoxFit.cover),
        ),
        Positioned(
          right: -8,
          top: -8,
          child: GestureDetector(
            key: const Key('remove_pickup_photo'),
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 11,
              backgroundColor: Color(0xFFFF3B5C),
              child: Icon(Icons.close, size: 13, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
