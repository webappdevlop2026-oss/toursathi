import 'dart:async';
import 'package:flutter/material.dart';

/// UI demo carousel. Photos are illustrative, not verified Durgapur pandals.
class FestivalSlider extends StatefulWidget {
 const FestivalSlider({super.key});
 @override State<FestivalSlider> createState()=>_FestivalSliderState();
}
class _FestivalSliderState extends State<FestivalSlider> {
 final controller=PageController(viewportFraction:.94);
 Timer? timer;
 int index=0;
 final slides=const [
  ('শুভ দুর্গাপূজা','আলোর উৎসবে ট্যুরসাথী','প্যান্ডেল • রুট • খাবার','https://images.unsplash.com/photo-1604541915015-5c2f956bf2c2?w=1200&q=85',Color(0xffb72c12),Icons.temple_hindu),
  ('নিজের পুজো ট্যুর','পছন্দের প্যান্ডেল দিয়ে রুট সাজান','সহজে ঘুরুন, সময় বাঁচান','https://images.unsplash.com/photo-1518005020951-eccb494ad742?w=1200&q=85',Color(0xff05276f),Icons.route),
  ('পুজোর স্বাদ','খাবার ও রেস্তোরাঁ খুঁজুন','বন্ধু ও পরিবারের সঙ্গে','https://images.unsplash.com/photo-1547573854-74d2a71d0826?w=1200&q=85',Color(0xff8d3c14),Icons.restaurant),
  ('আরামদায়ক থাকা','হোটেল ও থাকার ব্যবস্থা','দুর্গাপুর ভ্রমণ গাইড','https://images.unsplash.com/photo-1566073771259-6a8506099945?w=1200&q=85',Color(0xff174c54),Icons.hotel),
 ];
 @override void initState(){super.initState();timer=Timer.periodic(const Duration(seconds:5),(_){
  if(!mounted||!controller.hasClients)return;
  final next=(index+1)%slides.length;
  controller.animateToPage(next,duration:const Duration(milliseconds:550),curve:Curves.easeInOut);
 });}
 @override void dispose(){timer?.cancel();controller.dispose();super.dispose();}
 @override Widget build(BuildContext context)=>Column(children:[
  SizedBox(height:166,child:PageView.builder(controller:controller,itemCount:slides.length,onPageChanged:(i)=>setState(()=>index=i),
   itemBuilder:(context,i){final p=slides[i];return Container(
     margin:const EdgeInsets.symmetric(horizontal:5),
     clipBehavior:Clip.antiAlias,
     decoration:BoxDecoration(borderRadius:BorderRadius.circular(19),color:p.$5),
     child:Stack(fit:StackFit.expand,children:[
      Image.network(p.$4,fit:BoxFit.cover,errorBuilder:(ctx,e,s)=>Container(
       decoration:BoxDecoration(gradient:LinearGradient(colors:[p.$5,const Color(0xff091539)])),
       child:Align(alignment:Alignment.centerRight,child:Icon(p.$6,size:110,color:Colors.white24)))),
      const DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(
       colors:[Color(0xee07132d),Color(0x99071124),Color(0x00000000)]))),
      Padding(padding:const EdgeInsets.all(17),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
       Container(padding:const EdgeInsets.symmetric(vertical:4,horizontal:9),
        decoration:BoxDecoration(color:const Color(0xfffa1740),borderRadius:BorderRadius.circular(20)),
        child:const Text('TourSathi  •  দুর্গাপুর',style:TextStyle(fontSize:11,color:Colors.white,fontWeight:FontWeight.bold))),
       const Spacer(),
       Text(p.$1,style:const TextStyle(fontSize:24,color:Colors.white,fontWeight:FontWeight.w900)),
       Text(p.$2,style:const TextStyle(fontSize:15,color:Color(0xffffd36b),fontWeight:FontWeight.bold)),
       Text(p.$3,style:const TextStyle(fontSize:11,color:Colors.white)),
      ])),
     ]));})),
  const SizedBox(height:7),
  Row(mainAxisAlignment:MainAxisAlignment.center,children:[
   for(var i=0;i<slides.length;i++) AnimatedContainer(
    duration:const Duration(milliseconds:250),width:i==index?23:7,height:7,
    margin:const EdgeInsets.symmetric(horizontal:3),
    decoration:BoxDecoration(color:i==index?const Color(0xfff51c40):Colors.black26,borderRadius:BorderRadius.circular(12)))
  ]),
  const SizedBox(height:8)
 ]);
}
