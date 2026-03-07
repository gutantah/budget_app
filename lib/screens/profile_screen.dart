import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body:ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                height:200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://yt3.googleusercontent.com/86stVCEeQ3BBfiRtoP_ECbGy868rz_ToLt8yYdsR5wiRkxqocvAys7ymFf1XESVLKYb730cj=s900-c-k-c0x00ffffff-no-rj'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 150,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 46,
                  backgroundImage: NetworkImage('https://www.sheknows.com/wp-content/uploads/2023/01/lana-del-rey-1-1.jpg?w=1440'),
                  ),
                ),
              )
            ],
            ),
            SizedBox(height: 70),
            Center(
              child: Text(
                "John Doe",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          ),
          // Additional profile details can be added here
        ],
      ),
  );
}
}