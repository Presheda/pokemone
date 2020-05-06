
import 'package:pokemone/pokemon.dart';

abstract class PokeMonState {}


class LoadSuccess extends PokeMonState{
 final PokeHub pokeHub;

 LoadSuccess({this.pokeHub});

}

class IsLoading extends PokeMonState{}

class LoadFailure extends PokeMonState{}