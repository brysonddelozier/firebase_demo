import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'guest_book_message.dart';

enum Attending { yes, no, unknown }
enum Topping { pepperoni, sausage, veggies, unknown }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;
  bool _emailVerified = false;
  bool get emailVerified => _emailVerified;
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  int _attendees = 0;
  int get attendees => _attendees;

  int numPepperoni = 0;
  int numSausage = 0;
  int numVeggies = 0;

  Attending _attending = Attending.unknown;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;
  Attending get attending => _attending;
  set attending(Attending attending) {
    final userDoc = FirebaseFirestore.instance
        .collection('attendees')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (attending == Attending.yes) {
      userDoc.set(
        <String, dynamic>{'attending': true},
        SetOptions(merge: true),
      );
    } else {
      userDoc.set(
        <String, dynamic>{'attending': false},
        SetOptions(merge: true),
      );
      userDoc.set(
        <String, dynamic>{'topping': Topping.unknown.toString()},
        SetOptions(merge: true),
      );
    }
  }

  Topping _topping = Topping.unknown;
  StreamSubscription<DocumentSnapshot>? _toppingSubscription;
  Topping get topping => _topping;
  set topping(Topping topping) {
    final userDoc = FirebaseFirestore.instance
        .collection('attendees')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (topping == Topping.pepperoni) {
      userDoc.set(
        <String, String>{'topping': Topping.pepperoni.toString()},
        SetOptions(merge: true),
      );
    } else if (topping == Topping.sausage) {
      userDoc.set(
        <String, String>{'topping': Topping.sausage.toString()},
        SetOptions(merge: true),
      );
    } else if (topping == Topping.veggies) {
      userDoc.set(
        <String, String>{'topping': Topping.veggies.toString()},
        SetOptions(merge: true),
      );
    }
  }

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseFirestore.instance
        .collection('attendees')
        .where('attending', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      _attendees = snapshot.docs.length;
      notifyListeners();
    });

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
        _emailVerified = user.emailVerified;
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _guestBookMessages = [];
          for (final document in snapshot.docs) {
            _guestBookMessages.add(
              GuestBookMessage(
                name: document.data()['name'] as String,
                message: document.data()['text'] as String,
              ),
            );
          }
          notifyListeners();
        });
        _attendingSubscription = FirebaseFirestore.instance
            .collection('attendees')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.data() != null) {
            if (snapshot.data()!['attending'] as bool) {
              _attending = Attending.yes;
            } else {
              _attending = Attending.no;
            }
          } else {
            _attending = Attending.unknown;
          }
          notifyListeners();
        });
        _toppingSubscription = FirebaseFirestore.instance
            .collection('attendees')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
              int snapPep = 0;
              int snapSau = 0;
              int snapVeg = 0;
          if (snapshot.data() != null) {
            if (snapshot.data()!['topping'] == 'Topping.pepperoni') {
              _topping = Topping.pepperoni;
              snapPep += 1;
            } else if (snapshot.data()!['topping'] == 'Topping.sausage') {
              _topping = Topping.sausage;
              snapSau += 1;
            } else if (snapshot.data()!['topping'] == 'Topping.veggies') {
              _topping = Topping.veggies;
              snapVeg += 1;
            } else {
              _topping = Topping.unknown;
            }
          } else {
            _topping = Topping.unknown;
          }
          notifyListeners();
          numPepperoni = snapPep;
          numSausage = snapSau;
          numVeggies = snapVeg;
        });
      } else {
        _loggedIn = false;
        _emailVerified = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
        _attendingSubscription?.cancel();
        _toppingSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}