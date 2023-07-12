import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class menuBtn extends StatelessWidget {
  const menuBtn({
    super.key, 
    required this.press, 
    required this.riveOnit,
  });
  final VoidCallback press;
  final ValueChanged<Artboard> riveOnit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: Container(
        margin: const EdgeInsets.only(left: 13),
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFF86A1FF),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: RiveAnimation.asset(
          'assets/RiveAssets/menu.riv',
          onInit: riveOnit,
          fit: BoxFit.cover,
        ),
          ),
      ),
    );
  }
}
