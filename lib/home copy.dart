import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class HomePageTest extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageTest> {
  String? bearerToken;
  String? apiKey;

  getCredentials() async {
    bearerToken = dotenv.env['BEARER_TOKEN'].toString();
    apiKey = dotenv.env['API_KEY'].toString();
    setState(() {
      
    });
  }

  List<dynamic> recommendedMovies = [];
  List<dynamic> movies = [];
  int _current = 0;
  final CarouselController _carouselController = CarouselController();
  Map<int, String> genreMap = {}; // Map to store genre IDs and names

  @override
  void initState() {
    getCredentials();
    super.initState();
    fetchMovies();
    fetchGenres();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    final url =
        "https://api.themoviedb.org/3/movie/1022789/recommendations?language=en-US&page=1";
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $bearerToken'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> results = responseData['results'];

      // Limit results to 18 movies
      results = results.take(18).toList();

      setState(() {
        recommendedMovies = results;
      });
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<void> fetchMovies() async {
    final url =
        "https://api.themoviedb.org/3/movie/popular?api_key=${apiKey}";
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
        "https://api.themoviedb.org/3/genre/movie/list?api_key=${apiKey}";
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
    // Example list of image URLs for the buttons
    final buttonImages = [
      //disney button
      'https://s3-alpha-sig.figma.com/img/69c4/a9db/260917fb95df2ae915b2a71c498abe6b?Expires=1722816000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Rlifqtc-HP5sqCAjNYWKtOPaae-yJGawnkUIzO-vKUzPAbJEY-UMPkTRKW8SETNg4qE7dngy0QSBWJ7jR9mAe1brm3MKRbQ6XAsi1WjOoT8oNEXWm9GtZRhDjwPRbAxgqhixi8~dbXYbSNeuXOKCnE4gfCfgkub3JR2uFx3Slk~MMqZpMNUFivvBLmsRocCy--B9RnksRsud97CKwFVY1OAqMmJCM91ihw2lL3oVL5CqdpDbSP-1F-xQ-V3mQAOFiYB3LdrP6dkBh2JqQgCLkGAxQETK7j~NamxE1BCK~AJj-VakPaSzkulCIvxvdjD-bo9VRXr6RLCO5lsaUJ67kQ__',
      //pixar
      'https://s3-alpha-sig.figma.com/img/e30d/866a/537ba1750c2012a47d2f285e3a8b50a5?Expires=1722816000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OD-E7WE8KbLSFFR9jm7GFY8rhDlMBAPJ6I689i0IfCRZSnhxsMEKPAKF5EJq5Dkc-eKPRQ-J9Kjz7tiyyZy2ShtEIqBxP3wzjjZ615ZFoyYEAyQh1iZhLP99W80SgVo3o0oecZ2YRQojlQRJjWMjeiQBO7kFG2drotsFMVxlYhV3gpMxg7feK8XvxinzAfgk8CwpEfHrIyjnbDUslyTeqHNYs88ZPEWW99PMEZqUWUjHG5huBHosqVJzGYE8CK73yqTS6nmP8Rc7oadLDB-aQfhy0wwg8wrFbi-GbBe2G-~GgGDGv7JqDiSAxOo~0StRGmqzmrSx40DurbvKCKb64g__',
      //marvel
      'https://s3-alpha-sig.figma.com/img/b871/3a63/b8e431d706b34f9cc15f759afd8c56c8?Expires=1722816000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=JesYaSB03Pcf61K07-OZAVTrBuWo~y3xGPiEFXk3zgvM9iXPhUjlkJjie41mjllGbv0WsN1248MTGsGMboabxxeoMyXCoGg~MGOoQd0X-meEMZ~Zfa6xyRPyl1qgGs9nOk6QIhoiT-Fm-orlKXH5klQxVqr~OESx8M~wOYMXy3w3TlO3mF5VtHZnfU6DDbDnm~p2N0O9Ppn5r5LkZ3LsuKXWdz96kSdHEfozfLTDNQYlaAtTYhd0iJsyBFYB6Q7tbl3ch5BSLMbu65hfKAMgBHACUkvdjxzTn3qPkKxcpwVsEL0tvJm0G6BAKywZepyl9gCGUZzJbO7tcD2J0yM2Kw__',
    ];

    final buttonImages2 = [
      //star wars
      'https://s3-alpha-sig.figma.com/img/6b2e/6726/4495ebcbbf79a6191010f635e560d6af?Expires=1722816000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=H6Tz7Po4UDwgNvfxrKP5L-gKoyDirFNlB57nB6rPx0pNz3LGlzRDcjOAmqoyac5RWWZYoteoR73M7~u1UMYceFrwkssMq5aL~L8e9QAIZ8JSCUnl7YCp4ixB0MAD0BCOnF-l-UAy6Gsf3vJA8PY5rHa3eNpOEyNDZVORdAgaSrAUZSx3kJT2sj0iY3faVe9jl9KjvK0g74c-22wo-uqpj1XL9l4PQr0TvDEizQFZW~MAzjPWapc8oInkmOfjwEcCHobO8Ect9PqU9baZ4yvAGg~bdErM-qx6kRCBYSQtLuRwvG4vHAHU5wBJV-bp75QQA84Q3-KJn8AtM0s1TTjAnw__',
      //national geographic
      'https://s3-alpha-sig.figma.com/img/9474/bfa5/5915d71f526639904aad5c42e3e20f57?Expires=1722816000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=WgVcPXkm~Dw1zFoo1E3fBnxGnkd0pjC9Dc~DRD3f-Dtbv6ONPcvAUqD251gA7mJ30zRJpKZCVnp~6QI7vqvcoYgylRDO-GncSO9dhni9STgK6ZPLfLN4diLV8pOOIeiYlKpPFOBPGwBwcP5838KyHSyfWYp-Ieujnoy-kse1TbZRqzwmqOkKVynAGDDhq1s1zMadUh0snXq1fgFGImD8Q5eXbbJfgZtg8fHo~vq~aJDjQwqqtdblYyril1x1-f6eM9NJX53E2bordHZZ8-CbDbMMy2RafMLLSciyPB0Q82pI7F~0xjDAqlc~kLNob-WmVTGMP5EReKI2QLSlwKEh~A__',
      //STARS
      'https://s3-alpha-sig.figma.com/img/d3cf/8967/526215cdc4e1ce41f6bd954da9a76b7e?Expires=1722816000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=UxSl5G6JUz4SVfYtSA9co7bDqz80HBojT~FWa-QdmR0HL1AriWtvVC8Fehtk~-emEjUAt7gSsB4tHE-Hz3apxqzpUY2ZFiA-sGVsgZjuk1smPqE-qI0FsfsXEuGy5iKpFdzI2~PlKQVWLJIspea8gpjUERtXSftLeL3qSKYVuUWwI9hANGRG5FlBcXsEuRE0-IKmEdk6pDyqkjqLlb~XDYydDw012xwkkBzK21lQTLHdk3VEDtdVhBozk9cQGy4Fz3N5M17C3re6WoXthcHREeq7GTXDt8rkrMwwYjWqh4l7l3YdlLToy3WFuJA2YMCERzkSZQxxSkLnqP4YU6QrBA__',
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 16, 20, 1),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (movies.isEmpty || genreMap.isEmpty)
                  CircularProgressIndicator()
                else
                  Column(
                    children: [
                      _buildCarousel(),
                      SizedBox(
                          height: 10), // Space between carousel and buttons
                      _buildButtonRow(buttonImages),
                      SizedBox(
                        height: 5,
                      ),
                      _buildButtonRow(buttonImages2),
                      SizedBox(
                          height:
                              10), // Space between buttons and recommendations
                      _buildRecommendationsSection(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        // CarouselSlider
        CarouselSlider.builder(
          itemCount: movies.length,
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 450,
            autoPlay: false,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final movie = movies[index];
            final genreIds = movie['genre_ids'] as List<dynamic>;
            final genreNames = genreIds
                .map((id) => genreMap[id])
                .where((name) => name != null)
                .join(' · ');

            return Container(
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.network(
                    "https://image.tmdb.org/t/p/w500${movie['poster_path']}",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  Container(
                    width: double.infinity,
                    height: 170,
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
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RatingBarIndicator(
                                  rating: movie['vote_average'] / 2,
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.0),
                              Text(
                                '${movie['vote_average'].toStringAsFixed(1).replaceAll('.', ',')}',
                                style: TextStyle(
                                  color: Color.fromARGB(250, 239, 188, 20),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            genreNames,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Define your action here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(33, 34, 39, 1),
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  right: 30.0,
                                  left: 30.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 4.0),
                                Text(
                                  'Tonton Sekarang',
                                  style: TextStyle(
                                      fontSize: 13.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              // Define your action here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(33, 34, 39, 1),
                              padding: EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                              minimumSize: Size(40, 40),
                              maximumSize: Size(40, 40),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
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
        // Add Padding for space between Carousel and Indicators
        Padding(
          padding: const EdgeInsets.only(top: 10.0), // Adjust padding as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: movies.asMap().entries.map((entry) {
              int index = entry.key;
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(index),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index ? Colors.white : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekomendasi untuk kamu',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 0), // Adjust this value to reduce space
            child: _buildRecommendationGrid(recommendedMovies),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationGrid(List<dynamic> movies) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0), // Add vertical padding
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(), // Disable scrolling
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Show 3 movies per row
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.7, // Adjust aspect ratio to fit posters
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            color: Colors.grey[800], // Background color for each item
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttonImages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttonImages.map((imageUrl) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: ElevatedButton(
            onPressed: () {
              // Define your action here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(33, 34, 39, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 5,
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.contain,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
