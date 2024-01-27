import 'package:flutter/material.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    home: MovieListPage(),
  ));
}

class MovieListPage extends StatefulWidget {
  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<MovieData> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final _scrollController = ScrollController();
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadMovies() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String categoryPath = '';
    if (_selectedCategory != 'all') {
      categoryPath = '/${_selectedCategory.toLowerCase()}';
    }

    final response = await http.get(
      Uri.parse('https://uakino.club$categoryPath/page/$_currentPage/'),
    );
    final document = htmlParser.parse(response.body);

    final movieListElements =
        document.querySelectorAll('.movie-item.short-item');
    final movies = <MovieData>[];

    for (final element in movieListElements) {
      final titleElement = element.querySelector('.movie-title');
      final imgElement = element.querySelector('.movie-img img');
      final titleText = titleElement?.text;
      final imgSrc = 'https://uakino.club${imgElement?.attributes['src']}';

      if (titleText != null) {
        final pageLink = titleElement?.attributes['href'];
        movies.add(MovieData(
            title: titleText.trim(), imgSrc: imgSrc, pageLink: pageLink));
      }
    }

    setState(() {
      _movies.addAll(movies);
      _currentPage++;
      _isLoading = false;
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        actions: [
          DropdownButton<String>(
            value: _selectedCategory,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCategory = newValue;
                  _currentPage = 1;
                  _movies.clear();
                  _loadMovies();
                });
              }
            },
            items: <String>['all', 'filmy', 'cartoon', 'seriesss']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        controller: _scrollController,
        itemCount: _movies.length + 1,
        itemBuilder: (context, index) {
          if (index < _movies.length) {
            final movie = _movies[index];
            return GestureDetector(
              onTap: () {
                _launchURL(movie.pageLink!);
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        movie.imgSrc,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        movie.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container();
          }
        },
      ),
    );
  }
}

class MovieData {
  final String title;
  final String imgSrc;
  final String? pageLink;

  MovieData({required this.title, required this.imgSrc, this.pageLink});
}
