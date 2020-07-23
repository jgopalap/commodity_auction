import 'dart:async';

import 'package:ceylonteaauction/src/event/auction_event.dart';
import 'package:ceylonteaauction/src/event/authentication_event.dart';
import 'package:ceylonteaauction/src/event/login_event.dart';
import 'package:ceylonteaauction/src/model/login_state.dart';
import 'package:ceylonteaauction/src/model/repository/user_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'auction_list_bloc.dart';
import 'authentication_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository = UserRepository();
  final AuthenticationBloc authenticationBloc;
  final AuctionListBloc auctionBloc;

  LoginBloc({
    @required this.authenticationBloc,
    @required this.auctionBloc,
  })  : assert(authenticationBloc != null),
        assert(auctionBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      auctionBloc.add(InitializeAuctionList());
      try {
        final success = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        if (success) {
          authenticationBloc.add(LoggedIn());
        }

        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}