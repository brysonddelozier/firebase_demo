import 'package:flutter/material.dart';

import 'app_state.dart';
import 'src/widgets.dart';

class ToppingSelection extends StatelessWidget {
  const ToppingSelection(
      {super.key, required this.state, required this.onSelection});
  final Topping state;
  final void Function(Topping selection) onSelection;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case Topping.pepperoni:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FilledButton(
                onPressed: () => onSelection(Topping.pepperoni),
                child: const Text('PEPPERONI'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => onSelection(Topping.sausage),
                child: const Text('SAUSAGE'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => onSelection(Topping.veggies),
                child: const Text('VEGGIES'),
              ),
            ],
          ),
        );
      case Topping.sausage:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextButton(
                onPressed: () => onSelection(Topping.pepperoni),
                child: const Text('PEPPERONI'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => onSelection(Topping.sausage),
                child: const Text('SAUSAGE'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => onSelection(Topping.veggies),
                child: const Text('VEGGIES'),
              ),
            ],
          ),
        );
      case Topping.veggies:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextButton(
                onPressed: () => onSelection(Topping.pepperoni),
                child: const Text('PEPPERONI'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => onSelection(Topping.sausage),
                child: const Text('SAUSAGE'),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () => onSelection(Topping.veggies),
                child: const Text('VEGGIES'),
              ),
            ],
          ),
        );  
      case Topping.unknown:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextButton(
                onPressed: () => onSelection(Topping.pepperoni),
                child: const Text('PEPPERONI'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => onSelection(Topping.sausage),
                child: const Text('SAUSAGE'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => onSelection(Topping.veggies),
                child: const Text('VEGGIES'),
              ),
            ],
          ),
        );      
    }
  }
}