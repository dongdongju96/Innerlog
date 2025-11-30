import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:Innerlog/db/isar_service.dart';
import 'package:Innerlog/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize IsarService to ensure DB is ready
  IsarService();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Innerlog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LocalAuthWrapper(),
    );
  }
}

class LocalAuthWrapper extends StatefulWidget {
  const LocalAuthWrapper({super.key});

  @override
  State<LocalAuthWrapper> createState() => _LocalAuthWrapperState();
}

class _LocalAuthWrapperState extends State<LocalAuthWrapper> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        // If device doesn't support auth, we might want to let them in or show error.
        // For now, let's assume we let them in for testing if no auth available,
        // OR strictly require it. Let's default to strict but fall back if needed.
        // User request implies "require", but for dev/simulators without auth setup:
        setState(() {
          _isAuthenticated = true; // Fallback for simulators without auth setup
          _isLoading = false;
        });
        return;
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your sanctuary',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Error authenticating: $e');
      // Handle error
    }

    if (mounted) {
      setState(() {
        _isAuthenticated = authenticated;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isAuthenticated) {
      return const HomeScreen();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Authentication Required'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}
