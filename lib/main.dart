import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'supabase/supabase_config.dart';
import 'repository/shalat_repository.dart';
import 'viewmodel/shalat_view_model.dart';
import 'view/shalat_page.dart';

// Quran
import 'repository/quran_repository.dart';
import 'viewmodel/quran_view_model.dart';
import 'view/quran_page.dart';

// Doa
import 'repository/doa_repository.dart';
import 'viewmodel/doa_view_model.dart';
import 'view/doa_page.dart';

// Kiblat
import 'repository/qibla_repository.dart';
import 'viewmodel/qibla_view_model.dart';
import 'view/qibla_page.dart';

// Chat (AI)
import 'view/chat_page.dart';

// Auth
import 'repository/auth_repository.dart';
import 'viewmodel/auth_view_model.dart';
import 'view/login_page.dart';
import 'view/signup_page.dart';

// Home
import 'view/home_page.dart';

// Notes Pages
import 'view/profile_page.dart';
import 'view/shalat_notes_page.dart';
import 'view/ceramah_notes_page.dart';
import 'view/infaq_notes_page.dart';

// Tasbih
import 'view/tasbih_page.dart';

// Quotes
import 'view/quotes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) =>
              AuthViewModel(context.read<AuthRepository>())..initialize(),
        ),

        // Shalat Provider
        Provider<ShalatRepository>(create: (_) => ShalatRepository()),
        ChangeNotifierProvider<ShalatViewModel>(
          create: (context) =>
              ShalatViewModel(context.read<ShalatRepository>()),
        ),
        // Quran
        Provider<QuranRepository>(create: (_) => QuranRepository()),
        ChangeNotifierProvider<QuranViewModel>(
          create: (context) => QuranViewModel(context.read<QuranRepository>()),
        ),
        // Doa
        Provider<DoaRepository>(create: (_) => DoaRepository()),
        ChangeNotifierProvider<DoaViewModel>(
          create: (context) => DoaViewModel(context.read<DoaRepository>()),
        ),
        // Kiblat
        Provider<QiblaRepository>(create: (_) => QiblaRepository()),
        ChangeNotifierProvider<QiblaViewModel>(
          create: (context) => QiblaViewModel(context.read<QiblaRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muslim App',
        theme: ThemeData(useMaterial3: true),

        // Initial route based on auth state - handled in SplashScreen
        home: const AuthWrapper(),
        routes: {
          LoginPage.routeName: (_) => const LoginPage(),
          SignupPage.routeName: (_) => const SignupPage(),
          ShalatPage.routeName: (_) => const ShalatPage(),
          QuranPage.routeName: (_) => const QuranPage(),
          DoaPage.routeName: (_) => const DoaPage(),
          QiblaPage.routeName: (_) => const QiblaPage(),
          HomePage.routeName: (_) => const HomePage(),
          ChatPage.routeName: (_) => const ChatPage(),
          ProfilePage.routeName: (_) => const ProfilePage(),
          ShalatNotesPage.routeName: (_) => const ShalatNotesPage(),
          CeramahNotesPage.routeName: (_) => const CeramahNotesPage(),
          InfaqNotesPage.routeName: (_) => const InfaqNotesPage(),
          TasbihPage.routeName: (_) => const TasbihPage(),
          QuotesPage.routeName: (_) => const QuotesPage(),
        },
      ),
    );
  }
}

/// Auth Wrapper - checks auth state and shows appropriate screen
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Show loading while checking auth state
        if (!authViewModel.isLoggedIn) {
          return const LoginPage();
        }
        return const HomePage();
      },
    );
  }
}
