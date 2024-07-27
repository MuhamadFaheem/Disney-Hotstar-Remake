import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> movies = [];
  int _current = 0;
  final CarouselController _carouselController = CarouselController();
  Map<int, String> genreMap = {}; // Map to store genre IDs and names

  @override
  void initState() {
    super.initState();
    fetchMovies();
    fetchGenres();
  }

  Future<void> fetchMovies() async {
    final url =
        "https://api.themoviedb.org/3/movie/popular?api_key=da66f95e64c2fd81776b3e10ed244c00";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> results = responseData['results'];

      // Limit results to 5 movies
      results = results.take(5).toList();

      setState(() {
        movies = results;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<void> fetchGenres() async {
    final url =
        "https://api.themoviedb.org/3/genre/movie/list?api_key=da66f95e64c2fd81776b3e10ed244c00";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> genres = responseData['genres'];

      // Create a map of genre IDs to genre names
      Map<int, String> map = {};
      genres.forEach((genre) {
        map[genre['id']] = genre['name'];
      });

      setState(() {
        genreMap = map;
      });
    } else {
      throw Exception('Failed to load genres');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 16, 20, 1),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (movies.isEmpty || genreMap.isEmpty)
                CircularProgressIndicator()
              else
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: movies.length,
                          carouselController: _carouselController,
                          options: CarouselOptions(
                            height: 400,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            aspectRatio: 16 /
                                9, // Adjusted aspect ratio for wider images
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                            viewportFraction: 0.8,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            enlargeStrategy: CenterPageEnlargeStrategy.scale,
                          ),
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            return Container(
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  Image.network(
                                    "https://image.tmdb.org/t/p/w500${movies[index]['poster_path']}",
                                    fit: BoxFit.cover,
                                    width: double
                                        .infinity, // Expand image width to fill the container
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: Container(
                                      width: 350,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.black,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RatingBarIndicator(
                                            rating: movies[index]
                                                    ['vote_average'] /
                                                2, // normalize to 5-star scale
                                            itemCount: 5,
                                            itemSize: 20.0,
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors
                                                  .amber, // default star color
                                            ),
                                          ),
                                          // Add spacing between rating bar and text
                                          Text(
                                            '${movies[index]['vote_average'].toStringAsFixed(1).replaceAll('.', ',')}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  250, 239, 188, 20),
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Display all genre names based on genre_ids
                                          Text(
                                            movies[index]['genre_ids']
                                                .map((id) =>
                                                    genreMap[id] ?? 'Unknown')
                                                .join(' · '),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: movies.asMap().entries.map((entry) {
                            int index = entry.key;
                            return GestureDetector(
                              onTap: () =>
                                  _carouselController.animateToPage(index),
                              child: Container(
                                width: _current == index ? 10.0 : 7.0,
                                height: _current == index ? 10.0 : 7.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 16.0,
                      left: 0,
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          width: 400,
                          height: 100,
                          child: Text("")),
                    ),
                    Positioned(
                      right: 16.0,
                      left: 0,
                      top: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 400,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                "assets/homedisney.png",
                                width: 110,
                                height: 110,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 41,
                      left: 350,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            print("Broadcast ke device laen brow");
                          },
                          child: Ink.image(
                            image: AssetImage(
                                'assets/broadcast.png'), // Replace with your image path
                            width: 35, // Adjust width as needed
                            height: 35, // Adjust height as needed
                            fit: BoxFit
                                .contain, // Adjust the fit as per your requirement
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 215,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            print("Broadcast ke device laen brow");
                          },
                          child: Ink.image(
                            image: AssetImage(
                                'assets/subrek.png'), // Replace with your image path
                            width: 120, // Adjust width as needed
                            height: 120, // Adjust height as needed
                            fit: BoxFit
                                .contain, // Adjust the fit as per your requirement
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
