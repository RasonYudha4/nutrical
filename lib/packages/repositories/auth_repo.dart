import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../auth/models/User.dart';
import '../cache/cache_client.dart';

class AuthRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final CacheClient _cache = CacheClient();

  static const userCacheKey = '__user_cache_key__';

  static const userCacheTTL = Duration(hours: 1);

  Stream<User> get user {
    return _auth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user, ttl: userCacheTTL);
      return user;
    });
  }

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      firebase_auth.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> logOut() async {
    try {
      _cache.invalidate(userCacheKey);
      return await _auth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
