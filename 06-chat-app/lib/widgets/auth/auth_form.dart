import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function({
    required String email,
    required String password,
    required String username,
    File? image,
    required bool isLogin,
    required BuildContext context,
  }) onSubmit;
  final bool isLoading;

  const AuthForm(this.onSubmit, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;

  var _email = '';
  var _username = '';
  var _password = '';
  File? _userImage;

  void _trySubmit() {
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please pick an image', textAlign: TextAlign.center),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    form.save();
    widget.onSubmit(
      email: _email,
      password: _password,
      username: _username,
      image: _userImage,
      isLogin: _isLogin,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker((image) => _userImage = image),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email address'),
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                    },
                    onSaved: (value) => _email = value!.trim(),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim().length < 3) {
                          return 'Please enter at least 3 characters';
                        }
                      },
                      onSaved: (value) => _username = value!.trim(),
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.trim().length < 7) {
                        return 'Password must contain at least 7 characters';
                      }
                    },
                    onSaved: (value) => _password = value!.trim(),
                  ),
                  const SizedBox(height: 12),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      child: _isLogin ? const Text('Login') : const Text('Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      child: _isLogin ? const Text('Create a new account') : const Text('I already have an account'),
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
