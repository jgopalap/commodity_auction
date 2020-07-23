import 'dart:async';

import 'package:ceylonteaauction/src/event/authentication_event.dart';
import 'package:ceylonteaauction/src/model/authentication_state.dart';
import 'package:ceylonteaauction/src/model/repository/user_repository.dart';
import 'package:bloc/bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository = UserRepository();

  AuthenticationBloc();

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();


  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event
      ) async* {
    if (event is AppStarted) {
      final bool hasToken = UserRepository().currentUser != null;
      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      //await userRepository.persistToken(event.token);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      UserRepository().currentUser = null;

      yield AuthenticationLoading();
      //await userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    }
  }
}