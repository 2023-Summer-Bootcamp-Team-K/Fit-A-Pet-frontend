import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/page/create_page.dart';
import 'package:frontend/page/edit_page.dart';

class PetInfoPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PetInfoPage> {
  List<Container> containers = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Color(0xFFC1CCFF),
      appBar: AppBar(
        elevation: 0, //밑에 그림자 줄 없애기
        centerTitle: true,
        title: Text("Fit-A-Pet"),
        backgroundColor: Color(0xFFC1CCFF),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                      // User 정보를 표시할 부분
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
            SizedBox(height: 20),
            // 컨테이너와 간격을 표시
            ...containers.asMap().entries.map(
                  (entry) => Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.95, // 컨테이너 너비를 전체 너비의 90%로 설정
                        child: Stack(
                          children: [
                            entry.value,
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
                      SizedBox(height: 20),
                    ],
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToCreatePage(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFECB5FF),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

  void navigateToCreatePage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePage()),
    );

    if (result != null) {
      setState(() {
        final container = result as Container;
        containers.add(container);
      });
    }
  }

  // …
}
