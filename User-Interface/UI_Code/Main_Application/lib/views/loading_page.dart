
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget 
{
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
          (
            body: Column
                (
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: 
                  [
                    const SizedBox(height: 310,),
                    Center(child: Image.asset("assets/images/loading_img.png",width:150,height:200,)),
                    const SizedBox(height: 300,),
                    const Text("K^2PR",style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic,color: Colors.black38,letterSpacing: 1.25,fontWeight: FontWeight.w700 )),
                  ],
                ),
          );
  }
}