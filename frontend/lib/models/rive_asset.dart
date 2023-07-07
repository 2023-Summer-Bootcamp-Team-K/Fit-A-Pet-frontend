import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard;
  final String stateMachineName;
  final String title;
  final String src;
  late SMIBool? input;

  RiveAsset(this.src,{
    required this.artboard,
    required this.stateMachineName,
    required this.title,
  }) {
    input = null;
  }
}

List<RiveAsset> sideMenus = [
  RiveAsset(
    "assets/RiveAssets/menubar.riv", 
    artboard: "House", 
    stateMachineName:"House_interactivity", 
    title: "Pet Profile",
    ),
  RiveAsset(
    "assets/RiveAssets/menubar.riv", 
    artboard: "Paper", 
    stateMachineName:"Paper_interactivity", 
    title: "Chart",
    ),
  RiveAsset(
    "assets/RiveAssets/menubar.riv", 
    artboard: "Health", 
    stateMachineName:"Health_interactivity", 
    title: "Feed",
    ), 
  RiveAsset(
    "assets/RiveAssets/menubar.riv", 
    artboard: "Heart", 
    stateMachineName:"Heart_interactivity", 
    title: "LogOut",
    ),   
];
