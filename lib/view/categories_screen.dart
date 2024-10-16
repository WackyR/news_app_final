import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app_final/models/categories_model.dart';
import 'package:news_app_final/view/homescreen.dart';
import 'package:news_app_final/view_model/news_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app_final/view/news_details.dart';
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String category = 'Entertainment';
  List<String> categoryList = [
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
    'YouTube',
    'Amazon',
    'Facebook',
    'Google',
    'Weather',
    'Gmail',
    'Wordle',
    'Google Translate',
    'Walmart',
    'Home Depot',
    'NBA',
    'ESPN',
    'UFC',
    'Roblox',
    'Shein',
    'Twitch',
    'TikTok',
    'Apple',
  ];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryList.length,
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    category = categoryList[index];
                    setState(() {
                      
                    });

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: category == categoryList[index] ? Colors.red : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                              
                      ),
                            
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Center(child: Text(categoryList[index].toString(), style: GoogleFonts.roboto(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),)),
                      ),
                    ),
                  ),
                );
        
              }
            
            )
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: FutureBuilder<CategoriesModel>(
                future: NewsViewModel().getCategoriesAPI(category), 
                builder: (BuildContext context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: SpinKitRing(color: Colors.red, size: 50,),
                    );
            
                  }
                  else{
                    return ListView.builder(
                      itemCount: snapshot.data?.articles?.length ?? 0,

                      itemBuilder: (context, index){
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                      
                      return InkWell(
                        onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetails(
                          newsImage: snapshot.data!.articles![index].urlToImage.toString(), 
                          newsTitle: snapshot.data!.articles![index].title.toString(), 
                          newsDate: snapshot.data!.articles![index].publishedAt.toString(), 
                          author: snapshot.data!.articles![index].author.toString(), 
                          description: snapshot.data!.articles![index].description.toString(), 
                          content: snapshot.data!.articles![index].content.toString(),
                          source: snapshot.data!.articles![index].source!.name.toString(),
                          url: Uri.parse(snapshot.data!.articles![index].url!),
                          )));
                      },
                        
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  height: height * 0.18,
                                  width: width * 0.3,
                                  placeholder: (context, url) => Container(child: spinkit2),
                                  errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red,),
                                ),
                              ),
                              Expanded(child: Container(
                                height: height * .18,
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(children: [
                                  Text(snapshot.data!.articles![index].title.toString(),
                                  maxLines: 3 ,
                                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.white,
                                  fontWeight: FontWeight.w700
                                  
                                  ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    Text(snapshot.data!.articles![index].source!.name.toString(),
                                  
                                  style: GoogleFonts.roboto(fontSize: 12, color: Colors.white,
                                  fontWeight: FontWeight.w700
                                  
                                  ),
                                  ),
                                  Text(format.format(dateTime),
                                  maxLines: 3 ,
                                  style: GoogleFonts.roboto(fontSize: 12, color: Colors.white,
                                  fontWeight: FontWeight.w700
                                  
                                  ),
                                  ),
                                    
                                  ],)
                        
                                ],)
                              ),)
                            ],
                          ),
                        ),
                      );
                    });
            
                  }
                }),
          )
          

        ],),
      )
    );
  }
}