import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericInputField extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;
  final int min;
  final int max;

  const NumericInputField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value.toString()),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove, color: Colors.blue.shade700),
                onPressed: () {
                  final newValue = value - 1;
                  if (newValue >= min) {
                    onChanged(newValue);
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.add, color: Colors.blue.shade700),
                onPressed: () {
                  final newValue = value + 1;
                  if (newValue <= max) {
                    onChanged(newValue);
                  }
                },
              ),
            ],
          ),
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _NumberRangeFormatter(min, max),
      ],
      onChanged: (text) {
        if (text.isNotEmpty) {
          final newValue = int.parse(text);
          if (newValue >= min && newValue <= max) {
            onChanged(newValue);
          }
        }
      },
    );
  }
}

class _NumberRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _NumberRangeFormatter(this.min, this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value < min) {
      return TextEditingValue(
        text: min.toString(),
        selection: TextSelection.collapsed(offset: min.toString().length),
      );
    }

    if (value > max) {
      return TextEditingValue(
        text: max.toString(),
        selection: TextSelection.collapsed(offset: max.toString().length),
      );
    }

    return newValue;
  }
}
