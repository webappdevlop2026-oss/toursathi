
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
void main() => runApp(const MaterialApp(debugShowCheckedModeBanner:false,home:TourHome()));
class TourHome extends StatefulWidget {
 const TourHome({super.key});
 @override State<TourHome> createState()=>_TourHomeState();
}
class _TourHomeState extends State<TourHome> {
 int vehicle=0, radius=10, tab=0; String start='দুর্গাপুর',end='দুর্গাপুর',filter='';
 final saved=<int>{};
 final categories=const [
 (Icons.temple_hindu,'সব প্যান্ডেল','শহর ও এলাকা',Color(0xffffe0b3),Colors.red),
 (Icons.route,'প্যান্ডেল হপিং','সেরা রুট প্ল্যান',Color(0xffffd9df),Colors.pink),
 (Icons.restaurant,'খাবার ও রেস্তোরাঁ','কাছাকাছি খাবার',Color(0xffe4d7ff),Colors.deepPurple),
 (Icons.hotel,'হোটেল ও থাকার','বুকিং ও তথ্য',Color(0xffd0eefd),Colors.blue),
 (Icons.local_parking,'পার্কিং','নিকটবর্তী পার্কিং',Color(0xffe6f1cc),Colors.green),
 (Icons.groups,'গ্রুপ লাইভ','লাইভ লোকেশন',Color(0xffffe5c4),Colors.deepOrange),
 (Icons.notifications,'বন্ধু খুঁজুন','মোবাইল অ্যালার্ট',Color(0xffffd4de),Colors.pink),
 (Icons.map,'মন্দির দর্শন','কাছাকাছি মন্দির',Color(0xffd6f2ff),Colors.blue),
 (Icons.landscape,'দর্শনীয় স্থান','পাহাড়, লেক, প্রকৃতি',Color(0xffdef9d2),Colors.green),
 (Icons.local_gas_station,'পেট্রোল পাম্প','এবং গ্যারেজ',Color(0xffffe5c3),Colors.deepOrange),
 (Icons.medical_services,'জরুরি পরিষেবা','হাসপাতাল, পুলিশ',Color(0xffdbecff),Colors.blue),
 (Icons.calendar_month,'পুজোর সময়সূচি','তিথি ও ইভেন্ট',Color(0xffeadcff),Colors.deepPurple),
 ];
 final places=const [
 ('ডেমো প্যান্ডেল — সিটি সেন্টার','সিটি সেন্টার',23.5400,87.2890),
 ('ডেমো প্যান্ডেল — বেনাচিতি','বেনাচিতি',23.5580,87.2840),
 ('ডেমো প্যান্ডেল — বিধাননগর','বিধাননগর',23.5220,87.3120),
 ('ডেমো প্যান্ডেল — দুর্গাপুর','দুর্গাপুর',23.5500,87.3000),
 ];
 void soon(String title) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(title+' — সার্ভার সংযোগের পর চালু হবে')));
 Future<void> route(double lat,double lng) async {
 final url=Uri.https('www.google.com','/maps/dir/',{'api':'1','destination':lat.toString()+','+lng.toString(),'travelmode':'driving'});
 if(!await launchUrl(url,mode:LaunchMode.externalApplication)) soon('Maps');
 }
 @override Widget build(BuildContext context) {
 final matches=places.asMap().entries.where((e)=>(e.value.$1+e.value.$2).contains(filter)).toList();
 return Scaffold(backgroundColor:const Color(0xfffff9ef),body:SafeArea(child:ListView(children:[
 Container(constraints:const BoxConstraints(minHeight:310),padding:const EdgeInsets.all(15),decoration:const BoxDecoration(gradient:LinearGradient(colors:[Color(0xff031038),Color(0xff172258),Color(0xffb52f16)])),child:Stack(children:[
 Positioned(right:0,top:35,child:Icon(Icons.temple_hindu,size:175,color:Colors.amber.withOpacity(.45))),
 Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Row(children:[const Icon(Icons.location_on,color:Colors.white),const Expanded(child:Text('দুর্গাপুর, পশ্চিমবঙ্গ ⌄',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:17))),IconButton(onPressed:()=>soon('আবহাওয়া'),icon:const Icon(Icons.wb_cloudy,color:Colors.amber)),IconButton(onPressed:()=>soon('নোটিফিকেশন'),icon:const Icon(Icons.notifications,color:Colors.white)),const CircleAvatar(radius:15,child:Icon(Icons.person))]),
 const SizedBox(height:25),const Text('শুভ',style:TextStyle(fontSize:29,color:Colors.amber,fontWeight:FontWeight.w900)),
 const Text('দুর্গাপূজা 🌺',style:TextStyle(fontSize:42,color:Colors.amber,fontWeight:FontWeight.w900)),
 const Text('ঠাকুর দেখুন • ঘুরুন • খান • থাকুন',style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold)),
 const SizedBox(height:8),Container(padding:const EdgeInsets.symmetric(horizontal:16,vertical:6),color:const Color(0xfff5083c),child:const Text('সব এক অ্যাপে',style:TextStyle(fontSize:19,color:Colors.white,fontWeight:FontWeight.bold))),const SizedBox(height:8)
 ])])),
 Container(margin:const EdgeInsets.fromLTRB(12,0,12,12),padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20),boxShadow:const [BoxShadow(color:Colors.black12,blurRadius:9)]),child:Column(children:[
 Row(children:[
 Expanded(child:_input('কোথা থেকে যাবেন?',start,Colors.green,(s)=>start=s)),
 IconButton(icon:const Icon(Icons.swap_horiz,color:Colors.blue),onPressed:()=>setState((){final t=start;start=end;end=t;})),
 Expanded(child:_input('কোথায় ঘুরতে যাবেন?',end,Colors.red,(s)=>end=s))]),
 const SizedBox(height:9),
 SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:[
 for(var i=0;i<4;i++) Padding(padding:const EdgeInsets.only(right:6),child:ChoiceChip(selectedColor:Colors.blue,selected:vehicle==i,onSelected:(_)=>setState(()=>vehicle=i),label:Text(['গাড়ি','বাইক','বাস','ট্রেন'][i]),avatar:Icon([Icons.directions_car,Icons.two_wheeler,Icons.directions_bus,Icons.train][i],size:19)))
 ])),
 Row(children:[const Text('প্যান্ডেল সার্চ ব্যাসার্ধ'),const Spacer(),DropdownButton<int>(value:radius,items:[5,10,15,20,30].map((v)=>DropdownMenuItem(value:v,child:Text(v.toString()+' কিমি'))).toList(),onChanged:(v)=>setState(()=>radius=v??10))]),
 SizedBox(width:double.infinity,child:FilledButton.icon(onPressed:()=>soon('ট্যুর পরিকল্পনা'),style:FilledButton.styleFrom(backgroundColor:const Color(0xfff5083c),padding:const EdgeInsets.all(14)),icon:const Icon(Icons.search),label:const Text('ট্যুর পরিকল্পনা করুন',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold))))
 ])),
 Container(margin:const EdgeInsets.symmetric(horizontal:10),padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20)),child:GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:categories.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,childAspectRatio:.90,crossAxisSpacing:8,mainAxisSpacing:8),itemBuilder:(ctx,i){final c=categories[i];return InkWell(onTap:()=>soon(c.$2),child:Column(children:[
 Expanded(child:Container(width:double.infinity,decoration:BoxDecoration(color:c.$4,borderRadius:BorderRadius.circular(13)),child:Icon(c.$1,color:c.$5,size:37))),
 const SizedBox(height:3),Text(c.$2,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11,fontWeight:FontWeight.bold)),
 Text(c.$3,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:10,color:Colors.blueGrey))
 ]));})),
 SizedBox(height:135,child:ListView(scrollDirection:Axis.horizontal,padding:const EdgeInsets.all(10),children:[
 _promo('দুর্গাপুরের সেরা প্যান্ডেল','পুজো গাইড',const Color(0xff0a1745),Icons.temple_hindu),
 _promo('পুজো স্পেশাল খাবার','ফুচকা • বিরিয়ানি • মিষ্টি',const Color(0xff8c3a17),Icons.restaurant),
 _promo('আরামদায়ক হোটেল','পরিবার ও গ্রুপের জন্য',const Color(0xff665033),Icons.hotel),
 ])),
 const Padding(padding:EdgeInsets.all(12),child:Text('🔥 জনপ্রিয় প্যান্ডেল (দুর্গাপুর)',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold))),
 Padding(padding:const EdgeInsets.symmetric(horizontal:12),child:TextField(onChanged:(v)=>setState(()=>filter=v.trim()),decoration:InputDecoration(prefixIcon:const Icon(Icons.search),hintText:'প্যান্ডেল অথবা এলাকা খুঁজুন',filled:true,fillColor:Colors.white,border:OutlineInputBorder(borderRadius:BorderRadius.circular(13))))),
 const Padding(padding:EdgeInsets.fromLTRB(14,6,14,10),child:Text('ডেমো নাম ও আনুমানিক লোকেশন — বাস্তব প্যান্ডেল নয়',style:TextStyle(fontSize:12,color:Colors.deepOrange))),
 GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),padding:const EdgeInsets.symmetric(horizontal:10),itemCount:matches.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,mainAxisSpacing:10,crossAxisSpacing:10,childAspectRatio:.91),itemBuilder:(ctx,i){final entry=matches[i],p=entry.value;return Card(clipBehavior:Clip.antiAlias,color:Colors.white,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Expanded(child:Container(width:double.infinity,color:const Color(0xff111944),child:const Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.temple_hindu,color:Colors.amber,size:55),Text('ছবি শীঘ্রই আসছে',style:TextStyle(color:Colors.white,fontSize:11))]))),
 Row(children:[Expanded(child:Padding(padding:const EdgeInsets.only(left:7),child:Text(p.$1,maxLines:1,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:12,fontWeight:FontWeight.bold)))),IconButton(icon:Icon(saved.contains(entry.key)?Icons.favorite:Icons.favorite_border,color:Colors.red),onPressed:()=>setState(()=>saved.contains(entry.key)?saved.remove(entry.key):saved.add(entry.key)))]),
 Row(children:[const Icon(Icons.location_on,size:15,color:Colors.deepOrange),Expanded(child:Text(p.$2,maxLines:1,style:const TextStyle(fontSize:11))),IconButton(onPressed:()=>route(p.$3,p.$4),icon:const Icon(Icons.directions,color:Colors.blue))])
 ]));}),
 Padding(padding:const EdgeInsets.all(12),child:Row(children:[
 Expanded(child:_promo('আমার পুজো ট্যুর','নিজের রুট তৈরি করুন',Colors.green,Icons.route)),
 Expanded(child:_promo('বন্ধুদের সাথে লাইভ ট্যুর','গ্রুপ তৈরি করুন',Colors.deepPurple,Icons.groups))
 ]))
 ])),bottomNavigationBar:NavigationBar(height:67,selectedIndex:tab,onDestinationSelected:(i){setState(()=>tab=i);if(i!=0)soon(['হোম','প্যান্ডেল','রুট','খাবার','হোটেল','আরও'][i]);},destinations:const [
 NavigationDestination(icon:Icon(Icons.home),label:'হোম'),NavigationDestination(icon:Icon(Icons.location_on),label:'প্যান্ডেল'),NavigationDestination(icon:Icon(Icons.route),label:'রুট'),NavigationDestination(icon:Icon(Icons.restaurant),label:'খাবার'),NavigationDestination(icon:Icon(Icons.hotel),label:'হোটেল'),NavigationDestination(icon:Icon(Icons.grid_view),label:'আরও')
 ]));
 }
 Widget _input(String label,String value,Color color,ValueChanged<String> onChange)=>Container(padding:const EdgeInsets.all(8),decoration:BoxDecoration(border:Border.all(color:Colors.black12),borderRadius:BorderRadius.circular(12)),child:Row(children:[
 Icon(Icons.location_on,color:color,size:24),const SizedBox(width:4),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontSize:10,color:Colors.blueGrey)),TextFormField(initialValue:value,onChanged:onChange,decoration:const InputDecoration(isDense:true,border:InputBorder.none,contentPadding:EdgeInsets.zero),style:const TextStyle(fontSize:14,fontWeight:FontWeight.bold))]))
 ]));
 Widget _promo(String title,String subtitle,Color color,IconData icon)=>InkWell(onTap:()=>soon(title),child:Container(width:225,margin:const EdgeInsets.only(right:8),padding:const EdgeInsets.all(11),decoration:BoxDecoration(color:color,borderRadius:BorderRadius.circular(14)),child:Stack(children:[Positioned(right:0,bottom:0,child:Icon(icon,size:75,color:Colors.white24)),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:16)),Text(subtitle,style:const TextStyle(color:Colors.white70,fontSize:12))])]))); 
}
