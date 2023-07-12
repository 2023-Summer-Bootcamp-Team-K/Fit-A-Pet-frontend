import 'package:flutter/material.dart';
import 'package:frontend/components/side_menu.dart';
import 'package:frontend/constant.dart';
import 'package:rive/rive.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/models/rive_asset.dart';
import 'package:frontend/utils/rive_utils.dart';
import 'package:frontend/models/menu_btn.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  late SMIBool isSideBarClosed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack (
        children: [
          Positioned(
            width: 300,
            height: MediaQuery.of(context).size.height ,
            child: SideMenu(),
          ),
          Transform.translate(
            offset: Offset(300, 0),
            child: Transform.scale(
              scale: 1,
              child: HomeScreen()),
            ),
          menuBtn(
            riveOnInit: (artboard) {
              StateMachineController controller = RiveUtils.getRiveController(
                artboard, 
                stateMachineName: "State Machine");
                isSideBarClosed = controller.findSMI("isOpen") as SMIBool;
                isSideBarClosed.value = true; 
            },
            press: () {
              isSideBarClosed.value = !isSideBarClosed.value; 
            },
          ),
        ],
      ),

    );
  }
}
