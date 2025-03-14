import 'package:flutter/material.dart';

class CellinkTableSource extends DataTableSource {
  final List<List<DataCell>> allData;
  CellinkTableSource({required this.allData});

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: allData[index]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => allData.length;

  @override
  int get selectedRowCount => 0;
}
