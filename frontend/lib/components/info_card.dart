import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";


class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key, 
    required this.name, 
    required this.email,
  }) : super(key: key);

  final String name, email;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: 
        AssetImage('images/user.jpeg')
      ),
      title: Text(
        name,
      style: TextStyle(color: Colors.black),
      ),
      subtitle: Text(
        email,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
