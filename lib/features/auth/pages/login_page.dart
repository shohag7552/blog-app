// import 'package:blog_project/core/widgets/circles.dart';
import 'dart:math' as math;

import 'package:blog_project/core/widgets/circles.dart';
import 'package:blog_project/core/widgets/custom_snakebar.dart';
import 'package:blog_project/core/widgets/glass_text_field_container.dart';
import 'package:blog_project/features/post_create/pages/post_create_page.dart';
import 'package:blog_project/features/posts/pages/post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoginMode = true;

  final FocusNode _emailNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18391E),
      // appBar: AppBar(
      //   title: Text(_isLoginMode ? 'Login' : 'Register'),
      // ),
      body: Stack(
        children: [
          CirclesBackground(),

          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                customSnakeBar(context, state.message, isSuccess: false);

              } else if (state is AuthAuthenticated) {
                // Navigate to the main app page or home page
                // Navigator.of(context).pushReplacementNamed('/posts');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PostPage()),
                );
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(_isLoginMode ? 'Login' : 'Register',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 50),

                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailNode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordNode);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),

                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: TextStyle(color: Colors.white),

                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordNode,
                          textInputAction: _isLoginMode ? TextInputAction.done : TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_nameNode);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),

                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelStyle: TextStyle(color: Colors.white),

                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your password';
                            }
                            if (value!.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        if (!_isLoginMode) ...[
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameNode,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),

                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelStyle: TextStyle(color: Colors.white),

                            ),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is AuthLoading ? null : _submitForm,
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : Text(_isLoginMode ? 'Login' : 'Register'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoginMode = !_isLoginMode;
                            });
                          },
                          child: Text(_isLoginMode
                              ? 'Don\'t have an account? Register'
                              : 'Already have an account? Login',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isLoginMode) {
        context.read<AuthBloc>().add(
              AuthLoginRequested(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
      } else {
        context.read<AuthBloc>().add(
              AuthRegisterRequested(
                email: _emailController.text,
                password: _passwordController.text,
                name: _nameController.text,
              ),
            );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}