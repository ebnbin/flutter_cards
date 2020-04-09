part of '../data.dart';

//*********************************************************************************************************************

abstract class Grid {
  GridData get data;
}

class GridData {
  GridData._(this._grid);

  final _Grid _grid;

  bool get visible => card != null;

  Card get card {
    assert(_grid.card != null);
    return _grid.card;
  }
}

//*********************************************************************************************************************

class _Grid implements Grid {
  _Grid(this.card) {
    data = GridData._(this);
  }

  _Grid.placeholder() : this(null);

  final _Card card;

  @override
  GridData data;
}
