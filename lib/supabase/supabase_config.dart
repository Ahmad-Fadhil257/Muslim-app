import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Replace these with your actual Supabase credentials
  // You can get these from your Supabase dashboard:
  // Project Settings → API
  static const String supabaseUrl = 'https://vwnmrutxunhllawfpoib.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ3bm1ydXR4dW5obGxhd2Zwb2liIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMzNzgwNDAsImV4cCI6MjA4ODk1NDA0MH0.eSKGwm9iGo2osVKV9pCP2PhM4OLqd_E22jQEWXkX028';

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
