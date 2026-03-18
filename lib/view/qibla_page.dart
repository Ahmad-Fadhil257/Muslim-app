import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../viewmodel/qibla_view_model.dart';
import '../theme/app_theme.dart';

class QiblaPage extends StatefulWidget {
  static const routeName = '/qibla';
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  bool _isGettingLocation = false;
  Position? _currentPosition;

  // Kaaba coordinates
  static const double _kaabaLat = 21.422487;
  static const double _kaabaLng = 39.826206;

  Future<void> _checkAndGetLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showGpsDisabledDialog();
        setState(() {
          _isGettingLocation = false;
        });
        return;
      }

      // Check and request permission
      PermissionStatus permissionStatus = await Permission.location.status;
      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.location.request();
        if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
          _showPermissionDeniedDialog();
          setState(() {
            _isGettingLocation = false;
          });
          return;
        }
      }

      if (permissionStatus.isPermanentlyDenied) {
        _showPermissionDeniedDialog();
        setState(() {
          _isGettingLocation = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = position;
      });

      if (mounted) {
        // Calculate qibla direction
        context.read<QiblaViewModel>().fetchQibla(
          position.latitude,
          position.longitude,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan lokasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  void _showGpsDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_off, color: AppColors.accentGold),
            const SizedBox(width: 8),
            Text(
              'GPS Tidak Aktif',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Mohon aktifkan GPS Anda untuk menentukan arah kiblat.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open location settings
              Geolocator.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: Text(
              'Buka Pengaturan',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_disabled, color: AppColors.accentGold),
            const SizedBox(width: 8),
            Text(
              'Izin Lokasi Ditolak',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Mohon izinkan akses lokasi untuk menentukan arah kiblat.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open app settings
              openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: Text(
              'Buka Pengaturan',
              style: GoogleFonts.inter(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateQiblaDirection(double lat, double lng) {
    // Calculate bearing from current location to Kaaba
    final lat1 = lat * pi / 180;
    final lng1 = lng * pi / 180;
    final lat2 = _kaabaLat * pi / 180;
    final lng2 = _kaabaLng * pi / 180;

    final dLng = lng2 - lng1;

    final x = sin(dLng) * cos(lat2);
    final y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);

    var bearing = atan2(x, y) * 180 / pi;
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QiblaViewModel>();

    // Calculate qibla direction from current position
    double? qiblaDirection;
    if (_currentPosition != null) {
      qiblaDirection = _calculateQiblaDirection(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kiblat',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.lightGreen, AppColors.primaryGreen],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Location Info
                if (_currentPosition != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColors.accentGold,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Lokasi: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
                // Get Location Button
                ElevatedButton.icon(
                  onPressed: _isGettingLocation ? null : _checkAndGetLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentGold,
                    foregroundColor: AppColors.darkGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isGettingLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.darkGreen,
                          ),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    _isGettingLocation
                        ? 'Mendapatkan Lokasi...'
                        : 'Dapatkan Arah Kiblat',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),
                if (vm.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Gagal: ${vm.error}',
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (qiblaDirection != null) ...[
                  // Qibla Direction Display
                  Text(
                    'Arah Kiblat',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${qiblaDirection.toStringAsFixed(1)}°',
                    style: GoogleFonts.poppins(
                      color: AppColors.accentGold,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getDirectionName(qiblaDirection),
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Compass/Arrow
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.15),
                              border: Border.all(
                                color: AppColors.accentGold,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Transform.rotate(
                                angle: -qiblaDirection * pi / 180,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.navigation,
                                      size: 60,
                                      color: AppColors.accentGold,
                                    ),
                                    const SizedBox(height: 4),
                                    Icon(
                                      Icons.arrow_upward,
                                      size: 30,
                                      color: AppColors.accentGold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentGold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Putar ponsel menghadap kiblat',
                              style: GoogleFonts.poppins(
                                color: AppColors.darkGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.explore,
                            size: 80,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tekan tombol di atas untuk\nmenentukan arah kiblat',
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDirectionName(double degrees) {
    if (degrees >= 337.5 || degrees < 22.5) return 'Utara';
    if (degrees >= 22.5 && degrees < 67.5) return 'Timur Laut';
    if (degrees >= 67.5 && degrees < 112.5) return 'Timur';
    if (degrees >= 112.5 && degrees < 157.5) return 'Tenggara';
    if (degrees >= 157.5 && degrees < 202.5) return 'Selatan';
    if (degrees >= 202.5 && degrees < 247.5) return 'Barat Daya';
    if (degrees >= 247.5 && degrees < 292.5) return 'Barat';
    if (degrees >= 292.5 && degrees < 337.5) return 'Barat Laut';
    return '';
  }
}
