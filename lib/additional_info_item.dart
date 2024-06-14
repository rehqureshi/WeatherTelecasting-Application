import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String parameter;
  final String value;
  const AdditionalInfoItem(
      {super.key,
      required this.icon,
      required this.parameter,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 54,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(parameter),
        const SizedBox(
          height: 5,
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 26,
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
