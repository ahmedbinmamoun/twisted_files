import 'package:supabase_flutter/supabase_flutter.dart';

/// Singleton wrapper around SupabaseClient.
/// Replace the URL and anonKey with your actual Supabase project values.
class SupabaseService {
  static const String _supabaseUrl  = 'https://lzzgbbkafrgjotgbgvjt.supabase.co';
  static const String _supabaseKey  = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx6emdiYmthZnJnam90Z2Jndmp0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQxMDgxMTIsImV4cCI6MjA4OTY4NDExMn0.-bbIv1WQvLb5kEHZDZGvfAn8PpoVjpHuDr3SJwkPMDk';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
