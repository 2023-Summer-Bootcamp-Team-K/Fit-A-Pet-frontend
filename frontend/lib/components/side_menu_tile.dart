import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:frontend/models/rive_asset.dart';
class SideMenuTile extends StatelessWidget {
  const SideMenuTile({
    Key? key,
    required this.menu,
    required this.press,
    required this.riveonInit,
    required this.isActive,
  }) : super(key: key);

  final RiveAsset menu;
  final VoidCallback press;
  final ValueChanged<Artboard> riveonInit;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(
            color: Colors.black26,
            height: 6,
          ),
        ),
        Stack(
          children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                height: 65,
                width: isActive ? 300 : 0,
                left: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color:Color(0xFF6792FF),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                  ),
                ),
            ListTile(
              onTap: (){
              },
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: RiveAnimation.asset(
                    menu.src,
                    artboard: menu.artboard,
                    onInit: riveonInit,
                  ),
                ),
                title: Text(
                  menu.title,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
