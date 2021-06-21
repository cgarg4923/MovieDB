import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'signup_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final APIKey = '9c3dc084a086d78d96856ae13dfa3ce2';

class MovieInfo extends StatefulWidget {
  var movieId;
  String uid;
  MovieInfo({this.movieId, this.uid});
  @override
  _MovieInfoState createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  var vid;
  var list;
  var result, cast_crew;
  bool isFav, isWL;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  YoutubePlayerController _controller;
  void runPlayer(String url) {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url),
      flags: YoutubePlayerFlags(
        enableCaption: false,
        isLive: false,
        autoPlay: false,
      ),
    );
  }

  void fav_wl() async {
    var l = await firestore.collection("Users").doc(widget.uid).get();
    //print(l.data()['favourites']);
    setState(() {
      list = l.data();
    });
  }

  void apiCall() async {
    http.Response response = await http.get(
        'https://api.themoviedb.org/3/movie/${widget.movieId}?api_key=${APIKey}&language=en-US&append_to_response=videos,images');
    if (response.statusCode == 200) {
      setState(() {
        result = jsonDecode(response.body);
        vid = result['videos']['results'][0]['key'];
      });
    } else {
      print('error');
    }
    if (vid != null)
      runPlayer('https://www.youtube.com/watch?v=' + vid.toString());
  }

  void castCall() async {
    http.Response response = await http.get(
        'https://api.themoviedb.org/3/movie/${widget.movieId}/credits?api_key=${APIKey}&language=en-US');
    if (response.statusCode == 200) {
      setState(() {
        cast_crew = jsonDecode(response.body);
        // print(cast_crew);
      });
    } else {
      print('error');
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _controller.pause();
    super.deactivate();
  }

  @override
  void initState() {
    // TODO: implement initState

    apiCall();
    castCall();
    fav_wl();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool checker1() {
    if (list['favourites'].length == 0) {
      return false;
    } else {
      for (var items in list['favourites']) {
        if (items['id'] == widget.movieId) {
          return true;
        }
      }
    }
    return false;
  }

  bool checker2() {
    if (list['watch_later'].length == 0) {
      return false;
    } else {
      for (var items in list['watch_later']) {
        print(items);
        if (items['id'] == widget.movieId) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return list == null
        ? Center(child: CircularProgressIndicator())
        : YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
            ),
            builder: (context, player) {
              return Scaffold(
                body: result == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView(
                        children: [
                          Container(
                            child: Image.network(
                              'https://image.tmdb.org/t/p/original' +
                                  result['poster_path'],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ListTile(
                            title: Text(
                              result['original_title'],
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              result['tagline'],
                            ),
                          ),
                          Text(
                            ' Summary',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 6),
                            child: Text(
                              result['overview'],
                              style: TextStyle(letterSpacing: 1.1),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            ' Rating',
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  result['vote_average'].toString(),
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: result['vote_average'] >= 5
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                                Text(
                                  ' / 10',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(child: Container()),
                                RaisedButton(
                                  color: checker1()
                                      ? Colors.grey
                                      : Colors.lightBlueAccent,
                                  splashColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onPressed: () async {
                                    if (checker1()) {
                                      int ind;
                                      List temp = list['favourites'];
                                      for (int i = 0; i < temp.length; i++) {
                                        if (temp[i]['id'] == widget.movieId) {
                                          ind = i;
                                          break;
                                        }
                                      }
                                      temp.removeAt(ind);

                                      await firestore
                                          .collection('Users')
                                          .doc(widget.uid)
                                          .update({'favourites': temp});
                                    } else {
                                      List temp = list['favourites'];
                                      temp.add({
                                        'id': widget.movieId,
                                        'name': result['original_title'],
                                        'photo':
                                            'https://image.tmdb.org/t/p/original' +
                                                result['poster_path']
                                      });
                                      await firestore
                                          .collection('Users')
                                          .doc(widget.uid)
                                          .update({'favourites': temp});
                                    }
                                    setState(() {});
                                  },
                                  child: list == null
                                      ? null
                                      : checker1()
                                          ? Text('Remove fav.')
                                          : Text('Add to Fav.'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                RaisedButton(
                                  color: checker2()
                                      ? Colors.grey
                                      : Colors.lightBlueAccent,
                                  splashColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onPressed: () async {
                                    if (checker2()) {
                                      int ind;
                                      List temp = list['watch_later'];
                                      for (int i = 0; i < temp.length; i++) {
                                        if (temp[i]['id'] == widget.movieId) {
                                          ind = i;
                                          break;
                                        }
                                      }
                                      temp.removeAt(ind);

                                      await firestore
                                          .collection('Users')
                                          .doc(widget.uid)
                                          .update({'watch_later': temp});
                                    } else {
                                      List temp = list['watch_later'];
                                      temp.add({
                                        'id': widget.movieId,
                                        'name': result['original_title'],
                                        'photo':
                                            'https://image.tmdb.org/t/p/original' +
                                                result['poster_path']
                                      });
                                      await firestore
                                          .collection('Users')
                                          .doc(widget.uid)
                                          .update({'watch_later': temp});
                                    }
                                    setState(() {});
                                  },
                                  child: list == null
                                      ? null
                                      : checker2()
                                          ? Text('Remove W later')
                                          : Text('Watch Later'),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CastInfo1(type: cast_crew, val: 'cast'),
                          SizedBox(
                            height: 10,
                          ),
                          CastInfo1(type: cast_crew, val: 'crew'),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            ' Watch Trailer..',
                            style: TextStyle(fontSize: 20),
                          ),
                          Container(
                            child: vid == null
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 50.0),
                                      child: Text(
                                        'Trailer Coming Soon...',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  )
                                : player,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
              );
            },
          );
  }
}

class CastInfo1 extends StatelessWidget {
  var type;
  String val;
  CastInfo1({this.type, this.val});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          child: type == null
              ? Container()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: type[val].length,
                  itemBuilder: (context, index) => Container(
                    child: SizedBox(
                      height: 500,
                      width: 150,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: type[val][index]['profile_path'] == null
                                    ? Image.network(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4AaBuDwww3Humvzgp6koRDGO_drIw6NjTMg&usqp=CAU')
                                    : Image.network(
                                        'https://image.tmdb.org/t/p/original' +
                                            type[val][index]['profile_path'],
                                      ),
                              ),
                            ),
                            val == 'cast'
                                ? Text(type[val][index]['character'])
                                : Text(type[val][index]['job']),
                          ],
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
