import 'package:flutter/material.dart';
import 'package:frontend/utils/rive_utils.dart';
import 'package:rive/rive.dart';
import 'package:frontend/components/info_card.dart';
import 'package:frontend/components/side_menu_tile.dart';
import 'package:frontend/models/rive_asset.dart';

void main() {
  runApp(const SideMenu());
}

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

  class _SideMenuState extends State<SideMenu> {
    RiveAsset selectedMenu = sideMenus.first;
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0 * 2)
              ),
              color: Colors.white,
            ),
            width : 300,
            height: double.infinity,
            child: SafeArea(
              child: Column(     
                crossAxisAlignment: CrossAxisAlignment.start,          
                children: [
                  const InfoCard(name: "Duck UI", 
                  email: "DuckUI@demo.com",
                  ),
                  Padding(
                        padding: const EdgeInsets.only(left: 20, top: 32, bottom: 10),
                      child : Text(
                        "Menu  ".toUpperCase(),
                        style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.black38),                        
                      ),
                     ),
                  ...sideMenus.map(
                    (menu) => SideMenuTile(
                      menu: menu,
                      riveonInit: (artboard) {
                      StateMachineController controller =
                      RiveUtils.getRiveController(artboard,
                        stateMachineName: menu.stateMachineName);
                      menu.input = controller.findSMI("active") as SMIBool;
                      },
                      press: () {
                          menu.input!.change(true);
                            Future.delayed(const Duration(seconds: 1), () {
                        menu.input!.change(false);
                        });
                        setState(() {
                          selectedMenu = menu;
                        });
                    }, isActive: selectedMenu == menu,
                  ),
                 ),
                ],
              ),
            ),
          ),
        );
      }
    }
    
  
  