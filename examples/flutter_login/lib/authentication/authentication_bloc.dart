import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter_login/authentication/authentication.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  void onAppStart() {
    dispatch(AppStart());
  }

  void onLogin({@required String token}) {
    dispatch(Login(token: token));
  }

  void onLogout() {
    dispatch(Logout());
  }

  @override
  AuthenticationState get initialState => AuthenticationState.initializing();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState state, AuthenticationEvent event) async* {
    if (event is AppStart) {
      final bool hasToken = await _hasToken();

      if (hasToken) {
        yield AuthenticationState.authenticated();
      } else {
        yield AuthenticationState.unauthenticated();
      }
    }

    if (event is Login) {
      yield state.copyWith(isLoading: true);

      await _persistToken(event.token);
      yield AuthenticationState.authenticated();
    }

    if (event is Logout) {
      yield state.copyWith(isLoading: true);

      await _deleteToken();
      yield AuthenticationState.unauthenticated();
    }
  }

  Future<void> _deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> _persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> _hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}
