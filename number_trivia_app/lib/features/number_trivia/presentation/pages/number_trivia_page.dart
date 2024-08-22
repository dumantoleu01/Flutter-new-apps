import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia_app/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:number_trivia_app/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(builder: (context, state) {
                if (state is NumberTriviaInitialState) {
                  return const MessageDisplay(
                    message: 'Start searching!',
                  );
                } else if (state is NumberTriviaLoadingState) {
                  return const LoadingWidget();
                } else if (state is NumberTriviaLoadedState) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else if (state is NumberTriviaErrorState) {
                  return MessageDisplay(message: state.message);
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(
                height: 20,
              ),
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
