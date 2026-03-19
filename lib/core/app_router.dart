import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth_service.dart';
import '../models/user_model.dart';

import '../screens/auth/login_screen.dart';
import '../screens/admin/super_admin_dashboard.dart';
import '../screens/owner/owner_dashboard.dart';

// Provides the GoRouter instance
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.uri.path == '/login';

      if (authState.isLoading) return null;

      if (!isLoggedIn && !isAuthRoute) return '/login';
      
      if (isLoggedIn && isAuthRoute) {
        final user = authState.value;
        if (user != null) {
          try {
            final userRole = await ref.read(userRoleProvider(user.uid).future);
            if (userRole?.role == UserRole.superAdmin) {
              return '/admin';
            } else if (userRole?.role == UserRole.restaurantOwner) {
              return '/owner/${userRole?.restaurantId}';
            }
          } catch(e) {
            return null; // Stay on login if role check fails
          }
        }
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const SuperAdminDashboard(),
      ),
      GoRoute(
        path: '/owner/:id',
        builder: (context, state) => OwnerDashboard(
          restaurantId: state.pathParameters['id'] ?? '',
        ),
      ),
    ],
  );
});
