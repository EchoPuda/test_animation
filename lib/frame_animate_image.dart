import 'dart:async';
import 'package:flutter/material.dart';

/// Frame animation
/// @author jm
class FrameAnimateImage extends StatefulWidget {
  final List<String> _assetList;
  final double width;
  final double height;
  final int interval;

  FrameAnimateImage(this._assetList, {this.width, this.height, this.interval : 100});

  @override
  State<StatefulWidget> createState() {
    return _FrameAnimateImageState();
  }
}

class _FrameAnimateImageState extends State<FrameAnimateImage>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  int interval = 200;
  int index = 0;

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() {
    if (widget.interval != null) {
      interval = widget.interval;
    }

    final int imageCount = widget._assetList.length;
    final int maxTime = interval * imageCount;

    _controller = new AnimationController(
        duration: Duration(milliseconds: maxTime), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if(status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 2000), () {
          _controller.forward(from: 0.0);
        });
      }
    });

    _animation = new Tween<double>(begin: 0, end: imageCount.toDouble()).animate(_controller)
      ..addListener(() {
        setState(() {
          index = _animation.value.floor() % widget._assetList.length;
        });
      });

    _controller.forward();


  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return _buildImages();
  }

  Widget _buildImages() {

    return Image.asset(
      widget._assetList[index],
      width: widget.width,
      height: widget.height,
      gaplessPlayback: true,
    );

  }

}