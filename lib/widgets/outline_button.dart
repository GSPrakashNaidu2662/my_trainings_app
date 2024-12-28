import 'package:flutter/material.dart';

import '../utils/colors.dart';

class OutLButton extends StatelessWidget {
  const OutLButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.color});

  final String text;
  final Function onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        side: BorderSide(width: 0.5, color: color ?? greyColor),
      ),
      onPressed: () {
        onTap();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.tune, color: greyColor, size: 18),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(
                  color: greyColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 12)),
        ],
      ),
    );
  }
}
