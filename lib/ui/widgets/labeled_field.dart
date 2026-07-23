import 'package:flutter/material.dart';

class LabeledField extends StatefulWidget {
  const LabeledField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.showEye = false,
    this.keyboardType,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool showEye;
  final TextInputType? keyboardType;
  final bool enabled;

  @override
  State<LabeledField> createState() => _LabeledFieldState();
}

class _LabeledFieldState extends State<LabeledField> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: obscure,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: widget.showEye
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off: Icons.visibility),
                onPressed: () => setState(() => obscure = !obscure),
              )
            : null,
      ),
    );
  }
}
