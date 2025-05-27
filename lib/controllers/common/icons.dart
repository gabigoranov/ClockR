import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../theme_controller.dart';

final icons = {
  "bullet": SvgPicture.asset(
    'assets/svgs/bullet.svg',
    width: 18,
    height: 18,
  ),
  "blitz":SvgPicture.asset(
    'assets/svgs/blitz.svg',
    width: 24,
    height: 24,
  ),
  "rapid":SvgPicture.asset(
    'assets/svgs/rapid.svg',
    width: 24,
    height: 24,

  ),
  "classical":SvgPicture.asset(
    'assets/svgs/classical.svg',
    width: 24,
    height: 24,
  ),
};