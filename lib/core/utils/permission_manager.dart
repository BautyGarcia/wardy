import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// A utility class to manage permissions throughout the app.
class PermissionManager {
  /// Request camera permission and handle the result.
  /// Returns true if permission is granted, false otherwise.
  static Future<bool> requestCameraPermission(BuildContext context) async {
    return await _requestPermission(
      Permission.camera,
      'Camera',
      'This app needs camera access to take photos of your clothing items.',
      context,
    );
  }

  /// Request photo library permission and handle the result.
  /// Returns true if permission is granted, false otherwise.
  static Future<bool> requestPhotosPermission(BuildContext context) async {
    return await _requestPermission(
      Permission.photos,
      'Photos',
      'This app needs access to your photo library to select images of your clothing items.',
      context,
    );
  }

  /// Generic method to request any permission.
  /// Returns true if permission is granted, false otherwise.
  static Future<bool> _requestPermission(
    Permission permission,
    String permissionName,
    String rationale,
    BuildContext context,
  ) async {
    // Check current status
    PermissionStatus status = await permission.status;

    // If already granted, return true
    if (status.isGranted) {
      return true;
    }

    // If denied, request permission
    if (status.isDenied) {
      // Show rationale if needed
      if (context.mounted) {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text('$permissionName Permission Required'),
                content: Text(rationale),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }

      // Request the permission
      status = await permission.request();

      // Return true if granted
      return status.isGranted;
    }

    // If permanently denied, show settings dialog
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        final bool shouldOpenSettings =
            await showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('$permissionName Permission Required'),
                    content: Text(
                      'This feature requires $permissionName permission. '
                      'Please enable it in app settings.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Open Settings'),
                      ),
                    ],
                  ),
            ) ??
            false;

        if (shouldOpenSettings) {
          await openAppSettings();
        }
      }
      return false;
    }

    // For other cases (restricted, limited, etc.)
    return false;
  }
}
