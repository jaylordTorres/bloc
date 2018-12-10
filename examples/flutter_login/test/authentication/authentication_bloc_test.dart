import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_login/authentication/authentication.dart';

void main() {
  AuthenticationBloc authenticationBloc;

  setUp(() {
    authenticationBloc = AuthenticationBloc();
  });

  test('initial state is correct', () {
    expect(authenticationBloc.initialState, AuthenticationState.initializing());
  });

  test('dispose does not emit new states', () {
    expectLater(
      authenticationBloc.state,
      emitsInOrder([]),
    );
    authenticationBloc.dispose();
  });

  group('AppStarted', () {
    test('emits AuthenticationState.unauthenticated() for invalid token', () {
      final expectedResponse = [
        AuthenticationState.unauthenticated(),
      ];

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(AppStarted());
    });
  });

  group('Login', () {
    test('emits [loading, authenticated] when token is persisted', () {
      final expectedResponse = [
        AuthenticationState.initializing().copyWith(isLoading: true),
        AuthenticationState.authenticated(),
      ];

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(Login(
        token: 'instance.token',
      ));
    });
  });

  group('Logout', () {
    test('emits [loading, unauthenticated] when token is deleted', () {
      final expectedResponse = [
        AuthenticationState.initializing().copyWith(isLoading: true),
        AuthenticationState.unauthenticated(),
      ];

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(Logout());
    });
  });
}
