import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc/bloc.dart';

import './helpers/helpers.dart';

class MockBlocDelegate extends Mock implements BlocDelegate {}

void main() {
  group('Bloc Tests', () {
    group('Simple Bloc', () {
      SimpleBloc simpleBloc;
      MockBlocDelegate delegate;

      setUp(() {
        simpleBloc = SimpleBloc();
        delegate = MockBlocDelegate();
        when(delegate.onTransition(any)).thenReturn(null);

        BlocSupervisor().delegate = delegate;
      });

      test('dispose does not emit new states over the state stream', () {
        final List<String> expected = [''];

        expectLater(
          simpleBloc.state,
          emitsInOrder(expected),
        );

        simpleBloc.dispose();
      });

      test('initialState returns correct value', () {
        expect(simpleBloc.initialState, '');
      });

      test('state should equal initial state before any events are dispatched',
          () async {
        final initialState = await simpleBloc.state.first;
        expect(initialState, simpleBloc.initialState);
      });

      test('should map single event to correct state', () {
        final List<String> expected = ['', 'data'];

        expectLater(simpleBloc.state, emitsInOrder(expected)).then((dynamic _) {
          verify(
            delegate.onTransition(
              Transition<dynamic, String>(
                currentState: '',
                event: 'event',
                nextState: 'data',
              ),
            ),
          ).called(1);
        });

        simpleBloc.dispatch('event');
      });

      test('should map multiple events to correct states', () {
        final List<String> expected = ['', 'data', 'data', 'data'];

        expectLater(simpleBloc.state, emitsInOrder(expected)).then((dynamic _) {
          verify(
            delegate.onTransition(
              Transition<dynamic, String>(
                currentState: '',
                event: 'event1',
                nextState: 'data',
              ),
            ),
          ).called(1);
          verify(
            delegate.onTransition(
              Transition<dynamic, String>(
                currentState: 'data',
                event: 'event2',
                nextState: 'data',
              ),
            ),
          ).called(1);
          verify(
            delegate.onTransition(
              Transition<dynamic, String>(
                currentState: 'data',
                event: 'event3',
                nextState: 'data',
              ),
            ),
          ).called(1);
        });

        simpleBloc.dispatch('event1');
        simpleBloc.dispatch('event2');
        simpleBloc.dispatch('event3');
      });
    });

    group('Complex Bloc', () {
      ComplexBloc complexBloc;
      MockBlocDelegate delegate;

      setUp(() {
        complexBloc = ComplexBloc();
        delegate = MockBlocDelegate();
        when(delegate.onTransition(any)).thenReturn(null);

        BlocSupervisor().delegate = delegate;
      });

      test('dispose does not emit new states over the state stream', () {
        final List<ComplexState> expected = [];

        expectLater(
          complexBloc.state,
          emitsInOrder(expected),
        );

        complexBloc.dispose();
      });

      test('initialState returns ComplexStateA', () {
        expect(complexBloc.initialState, ComplexStateA());
      });

      test('state should equal initial state before any events are dispatched',
          () async {
        final initialState = await complexBloc.state.first;
        expect(initialState, complexBloc.initialState);
      });

      test('should map single event to correct state', () {
        final List<ComplexState> expected = [
          ComplexStateA(),
          ComplexStateA(),
        ];

        expectLater(complexBloc.state, emitsInOrder(expected))
            .then((dynamic _) {
          verify(
            delegate.onTransition(
              Transition<ComplexEvent, ComplexState>(
                currentState: ComplexStateA(),
                event: ComplexEventA(),
                nextState: ComplexStateA(),
              ),
            ),
          ).called(1);
        });

        complexBloc.dispatch(ComplexEventA());
      });

      test('should map multiple events to correct states', () {
        final List<ComplexState> expected = [
          ComplexStateA(),
          ComplexStateA(),
          ComplexStateB(),
          ComplexStateC(),
        ];

        expectLater(
          complexBloc.state,
          emitsInOrder(expected),
        ).then((dynamic _) {
          verify(
            delegate.onTransition(
              Transition<ComplexEvent, ComplexState>(
                currentState: ComplexStateA(),
                event: ComplexEventA(),
                nextState: ComplexStateA(),
              ),
            ),
          ).called(1);
          verify(
            delegate.onTransition(
              Transition<ComplexEvent, ComplexState>(
                currentState: ComplexStateA(),
                event: ComplexEventB(),
                nextState: ComplexStateB(),
              ),
            ),
          ).called(1);
          verify(
            delegate.onTransition(
              Transition<ComplexEvent, ComplexState>(
                currentState: ComplexStateB(),
                event: ComplexEventC(),
                nextState: ComplexStateC(),
              ),
            ),
          ).called(1);
        });

        complexBloc.dispatch(ComplexEventA());
        complexBloc.dispatch(ComplexEventB());
        complexBloc.dispatch(ComplexEventB());
        complexBloc.dispatch(ComplexEventC());
        complexBloc.dispatch(ComplexEventC());
      });
    });

    group('CounterBloc', () {
      CounterBloc counterBloc;
      MockBlocDelegate delegate;
      List<String> transitions;

      final OnTransitionCallback onTransitionCallback = (transition) {
        transitions.add(transition.toString());
      };

      setUp(() {
        transitions = [];
        counterBloc = CounterBloc(onTransitionCallback);
        delegate = MockBlocDelegate();
        when(delegate.onTransition(any)).thenReturn(null);

        BlocSupervisor().delegate = delegate;
      });

      test('initial state is 0', () {
        expect(counterBloc.initialState, 0);
        expect(transitions.isEmpty, true);
      });

      test('state should equal initial state before any events are dispatched',
          () async {
        final initialState = await counterBloc.state.first;
        expect(initialState, counterBloc.initialState);
      });

      test('single Increment event updates state to 1', () {
        final List<int> expected = [0, 1];
        final expectedTransitions = [
          'Transition { currentState: 0, event: Increment, nextState: 1 }'
        ];

        expectLater(
          counterBloc.state,
          emitsInOrder(expected),
        ).then((dynamic _) {
          expectLater(transitions, expectedTransitions);
          verify(
            delegate.onTransition(
              Transition<CounterEvent, int>(
                currentState: 0,
                event: Increment(),
                nextState: 1,
              ),
            ),
          ).called(1);
        });

        counterBloc.dispatch(Increment());
      });

      test('multiple Increment event updates state to 3', () {
        final List<int> expected = [0, 1, 2, 3];
        final expectedTransitions = [
          'Transition { currentState: 0, event: Increment, nextState: 1 }',
          'Transition { currentState: 1, event: Increment, nextState: 2 }',
          'Transition { currentState: 2, event: Increment, nextState: 3 }',
        ];

        expectLater(
          counterBloc.state,
          emitsInOrder(expected),
        ).then((dynamic _) {
          expect(transitions, expectedTransitions);
          verify(
            delegate.onTransition(
              Transition<CounterEvent, int>(
                currentState: 0,
                event: Increment(),
                nextState: 1,
              ),
            ),
          ).called(1);
          verify(
            delegate.onTransition(
              Transition<CounterEvent, int>(
                currentState: 1,
                event: Increment(),
                nextState: 2,
              ),
            ),
          ).called(1);
          verify(
            delegate.onTransition(
              Transition<CounterEvent, int>(
                currentState: 2,
                event: Increment(),
                nextState: 3,
              ),
            ),
          ).called(1);
        });

        counterBloc.dispatch(Increment());
        counterBloc.dispatch(Increment());
        counterBloc.dispatch(Increment());
      });
    });

    group('Async Bloc', () {
      AsyncBloc asyncBloc;
      MockBlocDelegate delegate;

      setUp(() {
        asyncBloc = AsyncBloc();
        delegate = MockBlocDelegate();
        when(delegate.onTransition(any)).thenReturn(null);

        BlocSupervisor().delegate = delegate;
      });

      test('dispose does not emit new states over the state stream', () {
        final List<ComplexState> expected = [];

        expectLater(
          asyncBloc.state,
          emitsInOrder(expected),
        );

        asyncBloc.dispose();
      });

      test('initialState returns correct initial state', () {
        expect(asyncBloc.initialState, AsyncState.initial());
      });

      test('state should equal initial state before any events are dispatched',
          () async {
        final initialState = await asyncBloc.state.first;
        expect(initialState, asyncBloc.initialState);
      });

      test('should map single event to correct state', () {
        final List<AsyncState> expected = [
          AsyncState(isLoading: false, hasError: false, isSuccess: false),
          AsyncState(isLoading: true, hasError: false, isSuccess: false),
          AsyncState(isLoading: false, hasError: false, isSuccess: true),
        ];

        expectLater(asyncBloc.state, emitsInOrder(expected)).then((dynamic _) {
          verify(
            delegate.onTransition(
              Transition<AsyncEvent, AsyncState>(
                currentState: AsyncState(
                  isLoading: false,
                  hasError: false,
                  isSuccess: false,
                ),
                event: AsyncEvent(),
                nextState: AsyncState(
                  isLoading: true,
                  hasError: false,
                  isSuccess: false,
                ),
              ),
            ),
          ).called(1);
          verify(
            delegate.onTransition(
              Transition<AsyncEvent, AsyncState>(
                currentState: AsyncState(
                  isLoading: true,
                  hasError: false,
                  isSuccess: false,
                ),
                event: AsyncEvent(),
                nextState: AsyncState(
                  isLoading: false,
                  hasError: false,
                  isSuccess: true,
                ),
              ),
            ),
          ).called(1);
        });

        asyncBloc.dispatch(AsyncEvent());
      });
    });

    group('== operator', () {
      test('returns true for the same two CounterBlocs', () {
        final CounterBloc _blocA = CounterBloc();
        final CounterBloc _blocB = CounterBloc();

        expect(_blocA == _blocB, true);
      });

      test('returns false for the two different Blocs', () {
        final CounterBloc _blocA = CounterBloc();
        final ComplexBloc _blocB = ComplexBloc();

        expect(_blocA == _blocB, false);
      });
    });
  });
}
