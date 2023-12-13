import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconItemRow extends StatelessWidget {
  final String title;
  final String icon;
  final String value;
  final Function()? onTap;
  const IconItemRow({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 20,
            height: 20,
            color: const Color(0xffC1C1CD),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: Color(0xffA2A2B5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: onTap,
            child: Image.asset("images/next.png",
                width: 12, height: 12, color: const Color(0xffA2A2B5)),
          )
        ],
      ),
    );
  }
}

class IconItemSwitchRow extends StatelessWidget {
  final String title;
  final String icon;
  final bool value;
  final Function(bool) didChange;

  const IconItemSwitchRow(
      {super.key,
      required this.title,
      required this.icon,
      required this.didChange,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 20,
            height: 20,
            color: const Color(0xffC1C1CD),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Spacer(),
          const SizedBox(
            width: 8,
          ),
          CupertinoSwitch(value: true, onChanged: didChange)
        ],
      ),
    );
  }
}
