
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _navy=Color(0xff092b65);
const _red=Color(0xfff51c40);
class TourSectionPage extends StatefulWidget {
 final String section;
 const TourSectionPage({super.key,required this.section});
 @override State<TourSectionPage> createState()=>_TourSectionPageState();
}
class _TourSectionPageState extends State<TourSectionPage> {
 String search='';
 int chosen=0;
 final liked=<int>{};
 final filters=<String>[];
 static const entries=<String,List<(String,String,IconData)>>{
 'খাবার': [('বাংলার খাবার','খাবারের নমুনা ক্যাটাগরি',Icons.ramen_dining),('চা ও আড্ডা','স্থানীয় দোকানের তথ্য যোগ হবে',Icons.local_cafe),('মিষ্টি','যাচাই করা দোকান পরে আসবে',Icons.cake)],
 'হোটেল':[('হোটেল খুঁজুন','দুর্গাপুরের যাচাই করা হোটেল তালিকা যোগ হবে',Icons.hotel),('পরিবারের থাকার ব্যবস্থা','ভাড়া ও বুকিং API এখনও যুক্ত নয়',Icons.bed)],
 'পার্কিং':[('সিটি সেন্টার পার্কিং','নির্দিষ্ট পার্কিং স্থান যাচাই বাকি',Icons.local_parking),('বেনাচিতি পার্কিং','রেট ও খোলা থাকার তথ্য বাকি',Icons.directions_car)],
 'মন্দির দর্শন':[('নিকটবর্তী মন্দির','যাচাই করা মন্দিরের অবস্থান যোগ হবে',Icons.temple_hindu)],
 'দর্শনীয় স্থান':[('লেক ও পার্ক','আসল লোকেশন ও ছবি যোগ হবে',Icons.landscape),('ঐতিহাসিক স্থান','পর্যটন তথ্য যোগ হবে',Icons.museum)],
 'পেট্রোল পাম্প':[('নিকটবর্তী পেট্রোল পাম্প','Google Maps-এ অনুসন্ধান করুন',Icons.local_gas_station)],
 'পুজোর সময়সূচি':[('মহাষষ্ঠী','তিথি ও তারিখ যাচাই করে প্রকাশ করা হবে',Icons.event),('মহাসপ্তমী','পুজোর সূচি যাচাই করা বাকি',Icons.event),('মহাষ্টমী','পুজোর সূচি যাচাই করা বাকি',Icons.event),('মহানবমী','পুজোর সূচি যাচাই করা বাকি',Icons.event),('বিজয়া দশমী','পুজোর সূচি যাচাই করা বাকি',Icons.event)],
 'জরুরি পরিষেবা':[('জরুরি নম্বর: 112','ভারতের সমন্বিত জরুরি নম্বর',Icons.emergency),('পুলিশ: 100','জরুরি সহায়তা',Icons.local_police),('অ্যাম্বুলেন্স: 108','অঞ্চলভেদে প্রাপ্যতা যাচাই করুন',Icons.medical_services),('ফায়ার: 101','অগ্নিনির্বাপণ সহায়তা',Icons.fire_truck)],
 'বন্ধু খুঁজুন':[('বন্ধু আমন্ত্রণ','যোগাযোগের অনুমতিসহ বন্ধু খোঁজার ফিচার পরে আসবে',Icons.person_add)],
 'গ্রুপ লাইভ':[('নতুন গ্রুপ রাইড','যাচাই করা অ্যাকাউন্ট ও সম্মতিভিত্তিক লোকেশন শেয়ারিং পরে আসবে',Icons.groups)],
 'আমার প্ল্যান':[('আমার পছন্দের প্যান্ডেল','হোম স্ক্রিনের হার্ট চিহ্ন দিয়ে রুট তৈরি করুন',Icons.favorite),('আমার পরিকল্পনা','ডেমো রুট দেখতে হোমে যান',Icons.route)],
 'আরও':[('আবহাওয়া','আসল আবহাওয়ার API বাকি',Icons.cloud),('ট্যুর বাজেট','খরচের হিসাব',Icons.account_balance_wallet),('ফটো অ্যালবাম','ছবি সংরক্ষণের ফিচার বাকি',Icons.photo_library),('বন্ধু খুঁজুন','বন্ধু আমন্ত্রণ',Icons.notifications),('ট্যুর গাইড','সহায়ক তথ্য',Icons.map),('রেটিং ও রিভিউ','ভেরিফিকেশন বাকি',Icons.star),('সেটিংস','অ্যাপের তথ্য',Icons.settings),('আমাদের সম্পর্কে','TourSathi',Icons.info)],
 };
 String get group {
  final t=widget.section;
  if(t.contains('খাবার'))return 'খাবার';
  if(t.contains('হোটেল'))return 'হোটেল';
  if(t.contains('পার্কিং'))return 'পার্কিং';
  if(t.contains('মন্দির'))return 'মন্দির দর্শন';
  if(t.contains('দর্শনীয়'))return 'দর্শনীয় স্থান';
  if(t.contains('পেট্রোল'))return 'পেট্রোল পাম্প';
  if(t.contains('সময়সূচি'))return 'পুজোর সময়সূচি';
  if(t.contains('জরুরি'))return 'জরুরি পরিষেবা';
  if(t.contains('গ্রুপ'))return 'গ্রুপ লাইভ';
  if(t.contains('বন্ধু'))return 'বন্ধু খুঁজুন';
  if(t.contains('প্ল্যান'))return 'আমার প্ল্যান';
  return 'আরও';
 }
 List<String> get chips {
  switch(group) {
   case 'খাবার':return ['সব','নিরামিষ','আমিষ','বাঙালি','মিষ্টি'];
   case 'হোটেল':return ['সব','বাজেট','মিড-রেঞ্জ','প্রিমিয়াম'];
   case 'পার্কিং':return ['সব','গাড়ি','বাইক','পেইড'];
   case 'পুজোর সময়সূচি':return ['সব','ষষ্ঠী','সপ্তমী','অষ্টমী','নবমী','দশমী'];
   default:return ['সব'];
  }
 }
 Future<void> searchMaps(String q) async {
  final url=Uri.https('www.google.com','/maps/search/',{'api':'1','query':q+' Durgapur West Bengal'});
  await launchUrl(url,mode:LaunchMode.externalApplication);
 }
 Future<void> action(String name) async {
  if(group=='জরুরি পরিষেবা'){
   final number=RegExp(r'\d+').firstMatch(name)?.group(0);
   if(number!=null){await launchUrl(Uri.parse('tel:'+number));return;}
  }
  if(group=='পেট্রোল পাম্প'){await searchMaps('petrol pump');return;}
  if(group=='হোটেল'){await searchMaps('hotels');return;}
  if(group=='খাবার'){await searchMaps('restaurants');return;}
  await showDialog(context:context,builder:(ctx)=>AlertDialog(
   title:Text(name),content:const Text('এই অংশের বাস্তব ডেটা, লগইন বা API এখনও সংযুক্ত হয়নি। তাই ডেমো তথ্য দেখানো হচ্ছে।'),
   actions:[TextButton(onPressed:()=>Navigator.pop(ctx),child:const Text('ঠিক আছে'))]));
 }
 @override Widget build(BuildContext context) {
  final items=(entries[group]??entries['আরও']!).where((e)=>(e.$1+e.$2).contains(search)).toList();
  return Scaffold(backgroundColor:const Color(0xfff7f9fd),
    appBar:AppBar(backgroundColor:_navy,foregroundColor:Colors.white,title:Text(widget.section,style:const TextStyle(fontWeight:FontWeight.bold))),
    body:ListView(padding:const EdgeInsets.all(12),children:[
     if(group=='গ্রুপ লাইভ')Container(padding:const EdgeInsets.all(15),decoration:BoxDecoration(color:const Color(0xffd7f6e4),borderRadius:BorderRadius.circular(14)),child:Column(children:[
      const Text('গ্রুপ রাইড তৈরি করুন',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
      const Text('লোকেশন শেয়ার করতে প্রত্যেক সদস্যের স্পষ্ট সম্মতি দরকার।'),
      const SizedBox(height:10),FilledButton(onPressed:()=>action('নতুন গ্রুপ'),child:const Text('+ নতুন গ্রুপ তৈরি'))
     ])),
     if(group=='আমার প্ল্যান')Card(color:const Color(0xffffeef0),child:Padding(padding:const EdgeInsets.all(15),child:Column(children:[
      const Text('দুর্গাপূজা ট্যুর',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold)),
      const Text('প্যান্ডেল নির্বাচন করতে হোম স্ক্রিনে ♥ ব্যবহার করুন'),
      FilledButton(onPressed:()=>Navigator.pop(context),child:const Text('হোমে ফিরুন'))
     ]))),
     if(group!='জরুরি পরিষেবা') TextField(onChanged:(v)=>setState(()=>search=v.trim()),
        decoration:InputDecoration(prefixIcon:const Icon(Icons.search),hintText:'নাম অথবা এলাকা খুঁজুন',filled:true,fillColor:Colors.white,
        border:OutlineInputBorder(borderRadius:BorderRadius.circular(15)))),
     const SizedBox(height:10),
     SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:[
       for(var i=0;i<chips.length;i++) Padding(padding:const EdgeInsets.only(right:6),child:ChoiceChip(label:Text(chips[i]),selected:chosen==i,
       selectedColor:const Color(0xffd7e5ff),onSelected:(_)=>setState(()=>chosen=i)))
     ])),
     if(chosen!=0) const Padding(padding:EdgeInsets.all(8),child:Text('ফিল্টারের যাচাই করা তথ্য যুক্ত হওয়ার অপেক্ষায় আছে',style:TextStyle(color:Colors.deepOrange,fontSize:12))),
     const SizedBox(height:9),
     for(var i=0;i<items.length;i++) Card(color:Colors.white,margin:const EdgeInsets.only(bottom:9),child:ListTile(
       contentPadding:const EdgeInsets.symmetric(horizontal:10,vertical:6),
       leading:Container(width:65,height:66,decoration:BoxDecoration(color:const Color(0xffdcecff),borderRadius:BorderRadius.circular(9)),
        child:Icon(items[i].$3,color:_navy,size:37)),
       title:Text(items[i].$1,style:const TextStyle(fontWeight:FontWeight.bold)),
       subtitle:Text(items[i].$2),
       trailing:group=='জরুরি পরিষেবা'?const Icon(Icons.call,color:Colors.green):const Icon(Icons.chevron_right,color:_red),
       onTap:()=>action(items[i].$1),
     )),
     if(items.isEmpty)const Padding(padding:EdgeInsets.all(25),child:Center(child:Text('কোনো তথ্য পাওয়া যায়নি'))),
     const SizedBox(height:12),
     const Text('ডেমো স্ক্রিন: যাচাই করা ব্যবসা, প্যান্ডেল, রেটিং বা লাইভ অবস্থান এখনো প্রকাশ করা হয়নি।',
       textAlign:TextAlign.center,style:TextStyle(color:Colors.deepOrange,fontSize:12))
    ]));
 }
}
