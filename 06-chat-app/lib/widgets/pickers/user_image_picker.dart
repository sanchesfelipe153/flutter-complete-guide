import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) onImagePick;

  const UserImagePicker(this.onImagePick);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return; // aborted
    }
    final image = File(pickedImage.path);
    setState(() {
      _pickedImage = image;
    });
    widget.onImagePick(image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text('Add Image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
