import 'package:flutter/material.dart';

class BirthdayForm extends StatefulWidget {
  final Function(DateTime) onBirthdaySelected;

  BirthdayForm({required this.onBirthdaySelected});

  @override
  _BirthdayFormState createState() => _BirthdayFormState();
}

class _BirthdayFormState extends State<BirthdayForm> {
  late DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      widget.onBirthdaySelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedDate != null) Text("Selected date: ${_selectedDate.toString()}"),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: Text("Select birthday"),
        ),
      ],
    );
  }
}
