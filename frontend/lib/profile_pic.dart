import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  late File _image;

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Provider.of<User>(context, listen: false).userImage = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    ImageProvider imageProvider = user.userImage.isNotEmpty
        ? FileImage(File(user.userImage))
        : AssetImage("images/pet_basic.png") as ImageProvider;

    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: imageProvider,
          ),
          Positioned(
            right: -12,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: ElevatedButton(
                onPressed: getImage,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(color: Colors.white),
                  ),
                  backgroundColor: Color(0xFFF5F6F9),
                  padding: EdgeInsets.zero,
                ),
                child: SvgPicture.asset("assets/icons/ic_camera.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
