import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_demo/counter_app_example/web_socket_client.dart';

// Initializing provider and assigns initial value
final counterProvider = StateProvider((ref) => 0);

// Initializing provider and assigns initial value
final streamCounterProvider = StreamProvider<int>((ref) {
  final wsClient = ref.watch(websocketClientProvider);
  return wsClient.getCounterStream();
});

// Created fake web socket that will provide data 
// after every one second
final websocketClientProvider = Provider<WebsocketClient>(
  (ref) {
    return FakeWebsocketClient();
  },
);


// Convert your stateless widget into consumer widget
class CounterPage extends ConsumerWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep watch on the values of the providers
    final int counterValue = ref.watch(counterProvider);
    final AsyncValue<int> counter = ref.watch(streamCounterProvider);

    // Listen to the provider(perticuler value)
    // You need to pass the provider in listern ()
    ref.listen(
      counterProvider,
      (previous, next) {
        if (counterValue >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Value is >5 now be careful'),
            ),
          );
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions: [
          IconButton(
            // When reload button pressed it will invalidate the providers, 
            // So state can reset.
            onPressed: () {
              ref.invalidate(counterProvider);
              ref.invalidate(streamCounterProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        // Show value for manually incremented value (counter)
        //   child: Text(
        //    counter.toString(),
        //    style: Theme.of(context).textTheme.displayMedium,
        //  ),
        // Listen stream when value constatly increases from the stream
        child: Text(
          counter
              .when(
                  data: (int value) => value,
                  error: (Object e, _) => e,
                  loading: () => 0)
              .toString(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      // When button is pressed it will increases the value of the counter
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     ref.read(counterProvider.notifier).state++;
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
