import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class ProviderModel extends ChangeNotifier{
 var newsData;
 var searchData;
 Future fetchAllNews() async {
  var url= Uri.parse("https://61d2cc62b4c10c001712b5c5.mockapi.io/api/v1/news");
  final response = await http.get(url);
  if(response.statusCode == 200) {
   newsData = jsonDecode(response.body);
   // print(newsData);
  }
 }
 clearSearch(){
  searchData.clear();
 }
 Future searchAllNews(String query) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  Map<String, String> JsonBody = {
   'title':  query,
  };
  var url= Uri.parse("https://61d2cc62b4c10c001712b5c5.mockapi.io/api/v1/news");
  final response = await http.post(url,body: JsonBody);
  searchData = jsonDecode(response.body);
  print(searchData);
  print(response.statusCode);
 }
}