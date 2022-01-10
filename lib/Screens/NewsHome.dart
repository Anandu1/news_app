import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/Provider/ProviderModel.dart';
import 'package:provider/provider.dart';

class NewsHome extends StatefulWidget {
  const NewsHome({Key? key}) : super(key: key);

  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  TextEditingController textEditingController =TextEditingController();
  bool searchState=false;
  String searchQuery="";
  @override
  void initState() {
    Provider.of<ProviderModel>(context, listen: false).fetchAllNews();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:Provider.of<ProviderModel>(context, listen: false).fetchAllNews() ,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Icon(Icons.menu,color: Colors.black,),
          title: Text("NewsApp",style: TextStyle(color: Colors.black,),),
          actions: [
            searchState==false ?
            IconButton(onPressed: (){
              setState(() {
                searchState=true;
              });
            }, icon: Icon(Icons.search,color: Colors.black,)):
            IconButton(onPressed: (){
            setState(() {
              searchState=false;
            });
            }, icon: Icon(Icons.close,color: Colors.black,))
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10,),
              searchState==true ?
              Expanded(
                  flex: 2,
                  child: searchTextField()):Container(),
              SizedBox(height: 10,),
              searchState==true ? searchButton():Container(),
              SizedBox(height: 10,),
              searchState==true &&  Provider.of<ProviderModel>(context, listen: false).searchData!=null

        ?
              Expanded(
                flex: 16,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:1,
                    itemBuilder: (context,index){
                      return
                        // Provider.of<ProviderModel>(context, listen: false).searchData[index]==null ? Container():
                        newsTile(
                          Provider.of<ProviderModel>(context, listen: false).searchData["title"],
                          Provider.of<ProviderModel>(context, listen: false).searchData["image"],
                          Provider.of<ProviderModel>(context, listen: false).searchData["createdAt"]);
                    }),
              ):
              Provider.of<ProviderModel>(context, listen: false).newsData==null ? Container():
              Expanded(
                flex: 16,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:Provider.of<ProviderModel>(context, listen: false).newsData.length ,
                    itemBuilder: (context,index){
                      return newsTile(
                          Provider.of<ProviderModel>(context, listen: false).newsData[index]["title"],
                          Provider.of<ProviderModel>(context, listen: false).newsData[index]["image"],
                          Provider.of<ProviderModel>(context, listen: false).newsData[index]["createdAt"]);
                    }),
              ),
            ],
          ),
        ),
      );
    },

    );
  }
Widget newsTile(String title,Map image, int date){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            // Spacer(),
            Expanded(child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)),
            image.isEmpty ? Container():
            Expanded(child: Image.network(image["image"])),
            Expanded(child: Text(DateTime.fromMillisecondsSinceEpoch(date * 1000).toString().substring(0,19),
              style: TextStyle(color: Colors.grey[600],fontStyle: FontStyle.italic),))
          ],
        ),
      ),
    );
}
Widget searchTextField(){
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width*0.95,
      child: TextFormField(
        controller: textEditingController,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search),
          hintText: "Search Here....",
          border: OutlineInputBorder()
        ),
        onChanged: (val) => initiateSearch(val),
      ),
    );
}
Widget searchButton(){
    return  GestureDetector(
      onTap: (){
        setState(() {
          Provider.of<ProviderModel>(context, listen: false).searchAllNews(searchQuery);
        });
      },
      child: Container(
        height: 50,width: MediaQuery.of(context).size.width*0.75,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.black
        ),
        child: Center(child: Text("Search",style: TextStyle(color: Colors.white),)),
      ),
    );
}
  initiateSearch(String val) {
    setState(() {
      val.length==0 ? searchState=false:
      searchQuery=val.trim();
    });
  }
}
