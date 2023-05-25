import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:risuscito/core/core_container.dart';
import 'package:risuscito/core/presentation/customization/rs_colors.dart';
import 'package:risuscito/core/presentation/customization/theme/rs_theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../../core/infrastructure/localization/app_localizations.dart';

class SongPage extends StatefulWidget {
  final String? url;
  final WebViewPlus songWebView;
  final Color color;

  SongPage({
    Key? key,
    required this.url,
    required this.songWebView,
    required this.color,
  }) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration();
  StreamSubscription<Duration>? _positionSubscription;
  bool _isPlaying = false;
  bool _wasPlaying = false; // not reproducing audio
  bool _isDraggingSlider = false;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();

    SharedPreferences prefs = rs();
    if (prefs.getBool('always_on_display') ?? true)
      Wakelock.enable();
    else
      Wakelock.disable();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
    _positionSubscription =
        _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        if (!_isDraggingSlider)
          _sliderValue =
              position.inSeconds.toDouble() / _duration.inSeconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  void playRecording() async {
    await _audioPlayer.resume();
    setState(() {
      _isPlaying = true;
      _wasPlaying = true;
    });
  }

  void pauseRecording() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
      _wasPlaying = false;
    });
  }

  void seekToPosition(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: widget.color,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemFill,
        previousPageTitle: AppLocalizations.of(context)!.translate('back')!,
        middle: Text(
          AppLocalizations.of(context)!.translate('song')!,
          style: TextStyle(
            color: RSColors.black,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Container(
                // height: 1024,
                color: widget.color,
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                child: widget.songWebView,
              ),
            ),
            if (widget.url != null && widget.url!.isNotEmpty)
              FutureBuilder(
                future: _audioPlayer.setSourceUrl(widget.url!),
                builder: (context, snapshot) {
                  return Container(
                    // height: 150,
                    color: CupertinoColors.systemFill,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 64,
                      ),
                      child: Row(children: [
                        Expanded(
                          child: CupertinoSlider(
                            value: _sliderValue.isNaN ? 0 : _sliderValue,
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                                _isDraggingSlider = true;
                                if (_isPlaying) {
                                  _audioPlayer.pause();
                                  _isPlaying = false;
                                }
                              });
                              // seekToPosition(
                              //   Duration(
                              //     seconds:
                              //         (value * _duration.inSeconds).toInt(),
                              //   ),
                              // );
                            },
                            onChangeEnd: (double value) {
                              seekToPosition(
                                Duration(
                                  seconds:
                                      (value * _duration.inSeconds).toInt(),
                                ),
                              );
                              setState(() {
                                _sliderValue = value;
                                _isDraggingSlider = false;
                                if (!_isPlaying && _wasPlaying) {
                                  _audioPlayer.resume();
                                  _isPlaying = true;
                                }
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CupertinoButton(
                          color: RSColors.primary,
                          borderRadius: BorderRadius.circular(100),
                          padding: EdgeInsets.all(16),
                          child: snapshot.hasData
                              ? Icon(
                                  _isPlaying
                                      ? CupertinoIcons.pause
                                      : CupertinoIcons.play,
                                  color: RSColors.white,
                                )
                              : CupertinoActivityIndicator(
                                  color: RSColors.white,
                                ),
                          onPressed: snapshot.hasData
                              ? () {
                                  if (_isPlaying) {
                                    pauseRecording();
                                  } else {
                                    playRecording();
                                  }
                                }
                              : null,
                        )
                      ]),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
