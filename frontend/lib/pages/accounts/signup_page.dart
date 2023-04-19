import 'package:flutter/material.dart';
import 'package:frontend/components/custom_text_field.dart';
import 'package:frontend/components/rounded_outlined_button.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/custom_router.dart';
import 'login_consumer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _signupDisabled = false;

  void _signUp() async {
    setState(() => _signupDisabled = true);
    final isFormValid = _formKey.currentState!.validate();
    if (isFormValid) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_email.text, _username.text, _password.text);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
            CustomRouter.createPageRoute(const LoginConsumer()));
        showSuccessSnackBar(context, 'Account has been created.');
      } on Exception catch (e) {
        setState(() => _signupDisabled = false);
        showExceptionSnackBar(context, e);
      }
      return;
    }
    setState(() => _signupDisabled = false);
  }

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.dark
                            ? 'assets/logo-dark.png'
                            : 'assets/logo-light.png',
                        width: 220,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _email,
                      hintText: 'e.g. example@financepal.com',
                      labelText: 'Email',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter at least one character.',
                    ),
                    CustomTextField(
                      controller: _username,
                      hintText: 'e.g. MasterOfFinance1337',
                      labelText: 'Username',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter at least one character.',
                    ),
                    CustomTextField(
                      controller: _password,
                      labelText: 'Password',
                      obsecureText: true,
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Enter at least one character.',
                    ),
                    const SizedBox(height: 16),
                    Hero(
                      tag: 'accounts-button1',
                      child: RoundedOutlinedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        borderColor: Theme.of(context).colorScheme.tertiary,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        onPressed: _signupDisabled ? null : _signUp,
                        child: _signupDisabled
                            ? const SizedBox(
                                height: 50,
                                width: 50,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Create an account',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                      ),
                    ),
                    Hero(
                      tag: 'accounts-button2',
                      child: RoundedOutlinedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'I have an account already',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pushReplacement(
                          CustomRouter.createPageRoute(const LoginConsumer()),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
