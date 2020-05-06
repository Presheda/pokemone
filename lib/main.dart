import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pokemone/bloc/bloc.dart';
import 'package:pokemone/bloc/event.dart';
import 'package:pokemone/bloc/state.dart';
import 'package:pokemone/pokemon.dart';
import 'package:pokemone/pokemondetail.dart';

void main() => runApp(MaterialApp(
  title: "Poke App",
  home: HomePage(),
  debugShowCheckedModeBanner: false,
));

class HomePage extends StatefulWidget {



  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokemonBloc _pokemonBloc;


  @override
  void initState() {
    super.initState();
   _pokemonBloc = PokemonBloc();
    _pokemonBloc.add(PokeMonEvent.load);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poke App"),
        backgroundColor: Colors.cyan,
      ),
      body: BlocBuilder<PokemonBloc, PokeMonState>(
        bloc: _pokemonBloc,
        builder: (context, state) {
          if (state is IsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadSuccess) {

            return GridView.count(
              crossAxisCount: 2,
              children:
                  state.pokeHub.pokemon.map((poke) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PokeDetail(
                              pokemon: poke,
                            )));
                  },
                  child: Hero(
                    tag: poke.img,
                    child: Card(
                      elevation: 3.0,
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 100.0,
                            width: 100.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(poke.img))),
                          ),
                          Text(
                            poke.name,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ))
                  .toList(),
            );
          }

          if (state is LoadFailure) {
            return Center(child: Text("Error Occured. Please try again",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ));
          }

          return Center(
            child: Text("Unknown Error",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pokemonBloc.add(PokeMonEvent.load);
        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
