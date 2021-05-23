import 'dart:async';
import 'dart:convert';
import 'package:MovieApp/favourites.dart';
import 'package:MovieApp/login_page.dart';
import 'package:MovieApp/signup_page.dart';
import 'package:MovieApp/watchlater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'movie_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Function duringSplash = () {
    print('Something background process');
    int a = 123 + 23;
    print(a);

    if (a > 100)
      return 1;
    else
      return 2;
  };

  Map<int, Widget> op = {1: MyApp(), 2: MyApp()};

  runApp(MaterialApp(
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: CustomSplash(
      imagePath: 'images/splash.png',
      //backGroundColor: Colors.deepOrange,
      backGroundColor: Colors.white,
      animationEffect: 'zoom-in',
      logoSize: 200,
      home: MyApp(),
      customFunction: duringSplash,
      duration: 1800,
      type: CustomSplashType.StaticDuration,
      outputAndHome: op,
    ),
  ));
}

final APIKey = '9c3dc084a086d78d96856ae13dfa3ce2';
final baseURL = 'https://api.themoviedb.org/3';

var trending;
var latest;
var searchResult;
var comedy;
var horror;
var toprated;
List<String> appBartitle = ['MovieDB', 'Favourites', 'Watch Later'];
// const endPoints = {
//   trendingMovies: /trending/movie/week?api_key=${APIKey},
//   latestMovies: /movie/upcoming?api_key=${APIKey}&language=en-US,
//   topRated: /movie/top_rated?api_key=${APIKey}&language=en-US,
//   actionMovies: /discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&with_genres=28,
//   comedyMovies: /discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&with_genres=35,
//   horrorMovies: /discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&with_genres=27,
//   romanceMovies: /discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&with_genres=10749,
//   dramaMovies: /discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&with_genres=18,
//   searchTemp1: /search/movie?api_key=${APIKey}&language=en-US&page=1&include_adult=false&query=,
//   searchTemp2: /search/movie?api_key=${APIKey}&language=en-US&page=2&include_adult=false&query=,
//   searchGenre1: /discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=,
//   searchGenre2: /discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=2&with_genres=,
// };

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String uid;
  MyHomePage({this.uid});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void apiCall() async {
    http.Response response =
        await http.get(baseURL + '/trending/movie/week?api_key=${APIKey}');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        trending = result['results'];
      });
    }
    response = await http
        .get(baseURL + '/movie/upcoming?api_key=${APIKey}&language=en-US');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        latest = result['results'];
      });
    }

    response = await http
        .get(baseURL + '/movie/top_rated?api_key=${APIKey}&language=en-US');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        toprated = result['results'];
      });
    }

    response = await http.get(baseURL +
        '/discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&with_genres=35');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        comedy = result['results'];
      });
    }

    response = await http.get(baseURL +
        '/discover/movie?api_key=${APIKey}&language=en-US&sort_by=popularity.desc&with_genres=27');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        horror = result['results'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    apiCall();
    super.initState();
  }

  Widget bodys() {
    if (selectedIndex == 1) {
      return Favourites(
        uid: widget.uid,
      );
    } else {
      return WatchLater(
        uid: widget.uid,
      );
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await _firebaseAuth.signOut().then((_) {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.format_align_left_rounded),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        centerTitle: true,
        title: Text(appBartitle[selectedIndex]),
        elevation: 8,
        shadowColor: Colors.white30,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                print(widget.uid);
                showSearch(
                  context: context,
                  delegate: DataSearch(
                    fuid: widget.uid,
                    callBack: (String query) async {
                      print('called');
                      http.Response response = await http.get(baseURL +
                          '/search/movie?api_key=${APIKey}&language=en-US&page=1&include_adult=false&query=${query}');
                      if (response.statusCode == 200) {
                        var result = jsonDecode(response.body);
                        setState(() {
                          searchResult = result;
                        });
                      }
                    },
                  ),
                );
              }),
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                _signOut(context);
              }),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Colors.black.withOpacity(0.5)),
        child: Drawer(
          elevation: 5,
          child: null,
        ),
      ),
      drawerScrimColor: Colors.black.withOpacity(0.3),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 22,
        backgroundColor: Colors.black38,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: 'Watch Later',
          ),
        ],
        selectedIconTheme: IconThemeData(color: Colors.white, size: 26),
        selectedLabelStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      body: selectedIndex != 0
          ? bodys()
          : ListView(
              children: [
                MovieMap(
                  heading: 'Trending...',
                  type: trending,
                  uid: widget.uid,
                ),
                MovieMap(
                  heading: 'Top Rated...',
                  type: toprated,
                  uid: widget.uid,
                ),
                MovieMap(
                  heading: 'Latest...',
                  type: latest,
                  uid: widget.uid,
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.transparent,
                  width: 200,
                  height: 350,
                  child: ContainedTabBarView(
                    tabs: [
                      Text('Comedy'),
                      Text('Horror'),
                      // Text('Action'),
                      // Text('Drama'),
                      // Text('Romance')
                    ],
                    views: [
                      Container(
                        child: MovieMap(
                          heading: '',
                          type: comedy,
                          uid: widget.uid,
                        ),
                      ),
                      Container(
                        child: MovieMap(
                          heading: '',
                          type: horror,
                          uid: widget.uid,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class MovieMap extends StatelessWidget {
  var type;
  var heading;
  String uid;
  MovieMap({this.heading, this.type, this.uid});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                heading,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        Container(
          height: 210,
          child: type == null
              ? Container()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: type.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieInfo(
                              movieId: type[index]['id'],
                              uid: uid,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 10,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/original' +
                              type[index]['poster_path'],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  List<String> recents = ['hello', 'chirag'];
  Function callBack;
  var result;
  final String fuid;
  DataSearch({@required this.fuid, this.callBack});
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            searchResult['results'] = [];
          })
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    callBack(query);
    Timer(Duration(seconds: 1), () {
      print("Yeah, this line is printed after 3 seconds");
    });
    return searchResult == null
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: searchResult['results'].length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print('hhh');
                  print(searchResult['results'][index]['id']);
                  print(fuid);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieInfo(
                        movieId: searchResult['results'][index]['id'],
                        uid: fuid,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.movie_filter_outlined),
                  title: Text(searchResult['results'][index]['original_title']),
                ),
              );
            },
          );

    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    //var ans;
    List suggestions = query.length == 0 ? recents : [];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.movie_filter_outlined),
          title: Text(suggestions[index]),
        );
      },
    );
    throw UnimplementedError();
  }
}
