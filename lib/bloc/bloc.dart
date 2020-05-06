import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemone/bloc/event.dart';
import 'package:pokemone/bloc/event.dart';
import 'package:http/http.dart' as http;
import 'package:pokemone/bloc/state.dart';
import 'package:pokemone/pokemon.dart';

class PokemonBloc extends Bloc<PokeMonEvent, PokeMonState> {
  final url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  @override
  PokeMonState get initialState => IsLoading();

  @override
  Stream<PokeMonState> mapEventToState(PokeMonEvent event) async* {
    switch (event) {
      case PokeMonEvent.load:
        yield* loadPokemon();
    }
  }

  Stream<PokeMonState> loadPokemon() async* {
    try {
      var res = await http.get(url);
      if (res.statusCode == 200) {
        var decodedJson = jsonDecode(res.body);
        var pokeHub = PokeHub.fromJson(decodedJson);
        yield LoadSuccess(pokeHub: pokeHub);
      } else {
        yield LoadFailure();
      }
    } catch (_) {
      yield LoadFailure();
    }
  }
}
