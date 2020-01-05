import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:website_demo/classList.dart';
import 'package:website_demo/responsive_helper.dart';
import 'package:website_demo/services.dart';

class dashboard extends StatefulWidget {
  @override
  _dashboardState createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  List<Article> _articles = [];

  @override
  void initState() {
    _getArticles();
  }

  _getArticles() async {
    List<Article> articles =
        await services().fetchArticlesBySection('technology');
    setState(() {
      _articles = articles;
    });
  }

  _buildArticlesGrid(MediaQueryData mediaQuery) {
    List<GridTile> tiles = [];
    _articles.forEach((article) {
      tiles.add(_buildArticleTile(article, mediaQuery));
    });
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: GridView.count(
        crossAxisCount: responsiveNumGridTiles(mediaQuery),
        children: tiles,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _buildArticleTile(Article article, MediaQueryData mediaQuery) {
    return GridTile(
        child: GestureDetector(
      onTap: () {
        _launchURL(article.url);
      },
      child: Column(
        children: <Widget>[
          Container(
            height: responsiveImageHeight(mediaQuery),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                image: DecorationImage(
                    image: NetworkImage(article.imageUrl), fit: BoxFit.cover)),
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            height: responsiveTitleHeight(mediaQuery),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 1),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Text(
              article.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          Center(
            child: Text(
              "The New York Times\nTop Technology Articles",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          SizedBox(height: 15),
          _articles.length > 0
              ? _buildArticlesGrid(mediaQuery)
              : Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
