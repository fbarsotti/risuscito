import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../infrastructure/flavors.dart';

class DeviceInfoDialog extends StatelessWidget {
  DeviceInfoDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Device Info',
        style: TextStyle(color: F.color),
      ),
      content: _getContent(),
    );
  }

  Widget _getContent() {
    if (Platform.isAndroid) {
      return _androidContent();
    }

    if (Platform.isIOS) {
      return _iOSContent();
    }

    return Text("You're not on Android neither iOS");
  }

  Widget _iOSContent() {
    return FutureBuilder<IosDeviceInfo>(
        future: DeviceUtils.iosDeviceInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          IosDeviceInfo device = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTile('Flavor:', '${F.title}'),
                _buildTile('Build mode:',
                    '${enumName(DeviceUtils.currentBuildMode().toString())}'),
                _buildTile('Physical device?:', '${device.isPhysicalDevice}'),
                _buildTile('Device:', '${device.name}'),
                _buildTile('Model:', '${device.model}'),
                _buildTile('System name:', '${device.systemName}'),
                _buildTile('System version:', '${device.systemVersion}'),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return _buildTile(
                        'App version:', '${snapshot.data!.version}');
                  },
                ),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return _buildTile(
                        'App package name:', '${snapshot.data!.packageName}');
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _androidContent() {
    return FutureBuilder<AndroidDeviceInfo>(
        future: DeviceUtils.androidDeviceInfo(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();

          AndroidDeviceInfo? device = snapshot.data;
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildTile('Flavor:', '${F.banner}'),
                _buildTile('Build mode:',
                    '${enumName(DeviceUtils.currentBuildMode().toString())}'),
                _buildTile('Physical device?:', '${device?.isPhysicalDevice}'),
                _buildTile('Manufacturer:', '${device?.manufacturer}'),
                _buildTile('Model:', '${device?.model}'),
                _buildTile('Android version:', '${device?.version.release}'),
                _buildTile('Android SDK:', '${device?.version.sdkInt}'),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return _buildTile(
                        'App version:', '${snapshot.data?.version}');
                  },
                ),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return _buildTile(
                        'App package name:', '${snapshot.data?.packageName}');
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _buildTile(String key, String value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              key,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value))
        ],
      ),
    );
  }

  String enumName(String enumToString) {
    List<String> paths = enumToString.split(".");
    return paths[paths.length - 1];
  }
}

class DeviceUtils {
  static BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.release;
    }
    var result = BuildMode.profile;
    //Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.debug;
      return true;
    }());
    return result;
  }

  static Future<AndroidDeviceInfo> androidDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.androidInfo;
  }

  static Future<IosDeviceInfo> iosDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.iosInfo;
  }
}

enum BuildMode { debug, profile, release }
