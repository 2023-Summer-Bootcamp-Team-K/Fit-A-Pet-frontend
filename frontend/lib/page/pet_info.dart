import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/page/edit_page.dart';
import 'package:frontend/profile_pic.dart';

class PetInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Color(0xFFC1CCFF),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Fit-A-Pet"),
        backgroundColor: Color(0xFFC1CCFF),
      ),
      body: Column(
        children: [
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            SizedBox(
                              width: 102,
                              height: 102,
                              child: CircleAvatar(
                                backgroundImage: user.userImage.isNotEmpty
                                    ? FileImage(File(user.userImage))
                                    : AssetImage("images/pet_basic.png")
                                        as ImageProvider<Object>?,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    user.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                  buildUserField('나이:', user.userage,
                                      fontSize: 13),
                                  SizedBox(height: 13),
                                  buildUserField('사료:', user.userfood,
                                      fontSize: 13),
                                  SizedBox(height: 13),
                                  buildUserField(
                                      '인슐린 주사 일일 투여 횟수:', user.usercount,
                                      fontSize: 13),
                                  SizedBox(height: 13),
                                  buildUserField('성별:', user.usergender,
                                      fontSize: 13),
                                  SizedBox(height: 13),
                                  buildUserField('종:', user.userspecie,
                                      fontSize: 13),
                                  SizedBox(height: 13),
                                  buildUserField('필요 영양제:', user.usersupplement,
                                      fontSize: 13),
                                  SizedBox(height: 13),
                                  buildUserField('센서착용날짜:', user.usersensorwear,
                                      fontSize: 13),
                                  SizedBox(height: 13),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 30,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        navigateToEditPage(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void navigateToEditPage(BuildContext context) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Widget buildUserField(String label, String value, {double fontSize = 20}) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
        SizedBox(width: 8),
        Text(
          value ?? '',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      ],
    );
  }
}
