import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';

class NavBarWeget extends StatelessWidget {
  const NavBarWeget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child:Center(child: Text('hi'))),
        FloatingNavBar(items: [
          
          FloatingNavBarItem(title: "title", page: Text('page')),
          FloatingNavBarItem(title: "title2", page: Text('page2')),
        
        ], horizontalPadding: 20, color: Colors.red,)
      ],
    );
    // return FloatingNavBar(
    //     // resizeToAvoidBottomInset: false,
    //     color: Colors.green,
    //     items: [
    //       FloatingNavBarItem(
    //         iconData: Icons.home,
    //         title: 'Home',
    //         page: Text("1"),
    //       ),
    //       FloatingNavBarItem(
    //         iconData: Icons.account_circle,
    //         title: 'Account',
    //         page: Text("2"),
    //       )
    //     ],
    //     // selectedIconColor: Colors.white,
    //     // hapticFeedback: true,
    //     horizontalPadding: 40,
      
    // );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "iamngoni made it👏",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           TextField(
//             decoration: InputDecoration(
//               hintText: "Fixing insets issue",
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MyPage extends StatefulWidget {
//   @override
//   _MyPageState createState() => _MyPageState();
// }

// class _MyPageState extends State<MyPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Text(
//           "iamngoni is cool😎",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//       ),
//     );
//   }
// }