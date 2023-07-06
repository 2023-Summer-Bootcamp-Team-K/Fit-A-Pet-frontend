import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:frontend/components/info_card.dart';
import 'package:frontend/components/side_menu_tile.dart';
import 'package:frontend/models/rive_asset.dart';
import 'package:frontend/constant.dart';


void main() {
  runApp(const SideMenu());
}

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

  class _SideMenuState extends State<SideMenu> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body : Container(
            width : 300,
            height: double.infinity,
            color: Colors.deepPurple,
            child: SafeArea(
              child: Column(
                children: [
                  const InfoCard(name: "Duck UI", 
                  email: "DuckUI@demo.com",
                  ),
                  Padding(
                        padding: const EdgeInsets.only(left: 0, top: 32, bottom: 16),
                      child : Text(
                        "Menu  ".toUpperCase(),
                        style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black38),                        
                      ),
                     ),
                   Container(
                    decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(1000.0 * 2),
                          ),
                        ),
                     ),
                  ...sideMenus.map(
                    (menu) => SideMenuTile(
                      menu: menu,
                      riveonInit: (artboard) {
                      // StateMachineController controller =
                      //   RiveUtils.getRiveController(artboard);
                      },
                      press: () {},
                      isActive: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  