import 'package:ceylonteaauction/src/bloc/auction_list_bloc.dart';
import 'package:ceylonteaauction/src/bloc/authentication_bloc.dart';
import 'package:ceylonteaauction/src/bloc/login_bloc.dart';
import 'package:ceylonteaauction/src/model/repository/user_repository.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            auctionBloc: BlocProvider.of<AuctionListBloc>(context)
          );
        },
        child: LoginForm(),
      ),
    );
  }
}