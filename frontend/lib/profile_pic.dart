import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; //svg 임포트 필수
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/page/home_page.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //Sizedbox
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none, //같은 기능 // overflow: Overflow.visible
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("images/pet_basic.png"),
          ),
          Positioned(
            right: -12,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              // child: FlatButton(
              //     Padding: EdgeInsets.zero,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(50),
              //       side: BorderSide(color: Colors.white),
              //     ),
              //     color: Color(0xFFF5F6F9),
              //     onPressed: () {}
              //     child: SvgPicture.asset("assets/icons/ic_camera.svg"),
              //     ),
              child: ElevatedButton(
                onPressed: () {
                  // 버튼이 클릭되었을 때 수행할 동작
                },
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












// class ProfilePic extends StatelessWidget {
//   const ProfilePic({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       //Sizedbox
//       height: 115,
//       width: 115,
//       child: Stack(
//         fit: StackFit.expand,
//         clipBehavior: Clip.none, //같은 기능 // overflow: Overflow.visible
//         children: [
//           CircleAvatar(
//             backgroundImage: AssetImage("images/pet_basic.png"),
//           ),
//           Positioned(
//             right: -12,
//             bottom: 0,
//             child: SizedBox(
//               height: 46,
//               width: 46,
//               // child: FlatButton(
//               //     Padding: EdgeInsets.zero,
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(50),
//               //       side: BorderSide(color: Colors.white),
//               //     ),
//               //     color: Color(0xFFF5F6F9),
//               //     onPressed: () {}
//               //     child: SvgPicture.asset("assets/icons/ic_camera.svg"),
//               //     ),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // 버튼이 클릭되었을 때 수행할 동작
//                 },
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                     side: BorderSide(color: Colors.white),
//                   ),
//                   backgroundColor: Color(0xFFF5F6F9),
//                   padding: EdgeInsets.zero,
//                 ),
//                 child: SvgPicture.asset("assets/icons/ic_camera.svg"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
