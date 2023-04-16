import 'package:flutter/material.dart';

class ColumnButton extends StatelessWidget {
  final IconData icon;
  final dynamic path;
  const ColumnButton({super.key, required this.icon,required this.path});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>path));
      },
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: Colors.black,
            )),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
