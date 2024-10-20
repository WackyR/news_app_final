import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app_final/models/headlines.dart';
import 'package:news_app_final/view/news_details.dart';
import 'package:news_app_final/view_model/news_view_model.dart';
import 'package:news_app_final/view/categories_screen.dart';
import 'package:news_app_final/models/categories_model.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum FilterList{bbcNews, aryNews, independent, reuters, cnn, alJazeera}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedmenu;
  

  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png', height: 30, width: 30, color: Colors.white,),
        ),
        title: Container(
          alignment: Alignment.topCenter,
          child: Center(
            child: 
            Text('News', style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white), textAlign: TextAlign.center,),
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedmenu,
            onSelected: (FilterList item){
              if(FilterList.bbcNews.name == item.name){
                name = 'bbc-news';
              }
              if(FilterList.aryNews.name == item.name){
                name = 'ary-news';
              }
              if(FilterList.independent.name == item.name){
                name = 'independent';
              }
              if(FilterList.reuters.name == item.name){
                name = 'reuters';
              }
              if(FilterList.cnn.name == item.name){
                name = 'cnn';
              }
              if(FilterList.alJazeera.name == item.name){
                name = 'al-jazeera-english';
              }
              setState(() {
                selectedmenu = item;
              });
              
            },
            itemBuilder: (context) => <PopupMenuEntry<FilterList>> [
            const PopupMenuItem<FilterList>(
              value:FilterList.bbcNews,
              child: Text('BBC News'),
              ),
              const PopupMenuItem<FilterList>(
              value:FilterList.aryNews,
              child: Text('ARY News'),
              ),
              const PopupMenuItem<FilterList>(
              value:FilterList.independent,
              child: Text('Independent'),
              ),
              const PopupMenuItem<FilterList>(
              value:FilterList.reuters,
              child: Text('Reuters'),
              ),
              const PopupMenuItem<FilterList>(
              value:FilterList.cnn,
              child: Text('CNN'),
              ),
              const PopupMenuItem<FilterList>(
              value:FilterList.alJazeera,
              child: Text('AlJazeera'),
              ),
          ])
        ], 
      ),
      body:  ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlinesModel>(
              future: NewsViewModel().getNewsChannelHeadlines(name), 
              builder: (BuildContext context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: SpinKitRing(color: Colors.red, size: 50,),
                  );

                }
                else{
                  return ListView.builder(
                    itemCount: snapshot.data!.articles!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                    return InkWell(
                      onTap: (){
                        print(snapshot.data!.articles![index].url);
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
                      child: SizedBox(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: height * 0.6,
                            width: width * 0.9,
                            padding: EdgeInsets.symmetric(
                              horizontal: height * 0.02,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(child: spinkit2),
                                errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.red,),
                              ),
                            )
                          ),
                          Positioned(
                            bottom: 20,
                            child: Opacity(
                              opacity: 1,
                              child: Card(
                                elevation: 5,
                                color: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.all(15),
                                  height: height * 0.22,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: width * 0.7,
                                        child: Text(snapshot.data!.articles![index].title.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis, style:
                                        GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white, ),)
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: width * 0.7,
                                        child: 
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                          Text(snapshot.data!.articles![index].source!.name.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis, style:
                                        GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white, ),),
                                        Text(format.format(dateTime),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis, style:
                                        GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white, ),)
                                        ],),
                                      )
                              
                                    ],
                                  )
                                )
                              ),
                            ),
                          )
                        ],
                      ),
                                        ),
                    );
                  });

                }
              })
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesModel>(
                  future: NewsViewModel().getCategoriesAPI('Global'), 
                  builder: (BuildContext context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: SpinKitRing(color: Colors.red, size: 50,),
                      );
              
                    }
                    else{
                      return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
            
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
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                        Text(snapshot.data!.articles![index].source!.name.toString(),
                                      
                                      style: GoogleFonts.roboto(fontSize: 10, color: Colors.white,
                                      fontWeight: FontWeight.w700
                                      
                                      ),
                                      ),
                                      Text(format.format(dateTime),
                                      maxLines: 3 ,
                                      style: GoogleFonts.roboto(fontSize: 12, color: Colors.white,
                                      fontWeight: FontWeight.w700
                                      
                                      ),
                                      ),
                                        
                                      ],),
                                    )
                                      
                                  ],)
                                ),)
                              ],
                            ),
                          ),
                        );
                      });
              
                    }
                  }),
          ),
        ],
      )
    );
  }
}
const spinkit2 = SpinKitRing(color: Colors.red, size: 50);