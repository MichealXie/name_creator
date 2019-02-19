import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

const List<Color> themeColors = [Colors.blue, Colors.lightGreen, Colors.blueGrey];
var currentThemeColor = themeColors[0];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RandomWords(),
        ),
      ),
      theme: new ThemeData(
        primaryColor: currentThemeColor,
      )
    );
  }
}

class RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;

        if(index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }

    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(   // 新增如下20行代码 ...
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile
            .divideTiles(
              context: context,
              tiles: tiles,
            )
            .toList();
          
          return new Scaffold(
            appBar: new AppBar(title: Text('已保存的名字'),),
            body: new ListView(children: divided,)
          );
        },
      ),
    );
  }

  _changeTheme() {
    var colorIndex = themeColors.indexOf(currentThemeColor);
    var nextColorIndex = colorIndex == (themeColors.length - 1) ? 0 : colorIndex + 1;
    print(nextColorIndex);
    print(themeColors[nextColorIndex]);

    setState(() {
      currentThemeColor = themeColors[nextColorIndex];
    });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) _saved.remove(pair);
          else _saved.add(pair);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start up Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          ),
          new IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _changeTheme,
          )
        ],
      ),
      body: _buildSuggestions()
    );
  }
}

class RandomWords extends StatefulWidget{
  @override
  State createState() => new RandomWordsState();
}

