import 'package:MovieApp/movie_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Favourites extends StatefulWidget {
  String uid;

  Favourites({this.uid});
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var list;
  void temp() async {
    var result = await firestore.collection('Users').doc(widget.uid).get();
    setState(() {
      list = result['favourites'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    temp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 120) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      body: list == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: GridView.count(
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisCount: 2,
                children: List.generate(list.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MovieInfo(
                                    movieId: list[index]['id'],
                                    uid: widget.uid,
                                  )));
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 500,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(list[index]['photo']),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black.withOpacity(0.45),
                            ),
                            child: Center(
                              child: Text(
                                list[index]['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
    );
  }
}
