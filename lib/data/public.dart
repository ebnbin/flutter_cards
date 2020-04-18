part of '../data.dart';

//*********************************************************************************************************************

class Card2 {
  Card2._(this._card);

  final _Card _card;

  Rect get rect {
    if (_card == null) {
      return Rect.zero;
    }
    return (_card).rect;
  }

  Rect get spriteEntityRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 48.0,
    );
  }

  Rect get spriteWeaponRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 0.0,
      rect.width / 60.0 * 15.0,
      rect.width / 60.0 * 24.0,
      rect.width / 60.0 * 24.0,
    );
  }

  Rect get spriteWeaponValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 1.0,
      rect.width / 60.0 * 40.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteWeaponValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 5.0,
      rect.width / 60.0 * 40.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  double get spriteValueFontSize {
    if (_card == null) {
      return 14.0;
    }
    return rect.width / Metric.get().gridSize / (5.0 / 3.0);
  }

  Rect get spriteShieldRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 22.0,
      rect.width / 60.0 * 17.0,
      rect.width / 60.0 * 24.0,
      rect.width / 60.0 * 24.0,
    );
  }

  Rect get spriteShieldValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 29.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteShieldValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 51.0,
      rect.width / 60.0 * 29.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
    );
  }

  Rect get spriteHealthValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 35.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 39.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthValue2Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 43.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthValue3Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthValue4Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 51.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthStateRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 47.0,
      rect.width / 60.0 * 46.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
    );
  }

  Rect get spriteHealthStateValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 38.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteHealthStateValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 42.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteStateRect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 0.0,
      rect.width / 60.0 * 1.0,
      rect.width / 60.0 * 9.0,
      rect.width / 60.0 * 9.0,
    );
  }

  Rect get spriteStateValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 10.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }
  Rect get spriteStateValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 14.0,
      rect.width / 60.0 * 2.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteAmountValue0Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 1.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  Rect get spriteAmountValue1Rect {
    if (_card == null) {
      return Rect.zero;
    }
    return Rect.fromLTWH(
      rect.width / 60.0 * 5.0,
      rect.width / 60.0 * 48.0,
      rect.width / 60.0 * 4.0,
      rect.width / 60.0 * 6.0,
    );
  }

  @override
  String toString() {
    if (_card == null) {
      return "";
    }
    return _card.toString();
  }
}
