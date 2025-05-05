import 'package:flutter/material.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TruncateTable extends StatefulWidget with GetItStatefulWidgetMixin {
  TruncateTable({super.key});

  @override
  State<TruncateTable> createState() => _TruncateTableState();
}

class _TruncateTableState extends State<TruncateTable> with GetItStateMixin {
  String? message;
  String? tableChoosen;
  List<String> tables = [
    'User',
    'Salesman',
    'SubAgent',
    'Agent',
    'Shop',
    'SalesmanCommission',
    'SubAgentCommission',
    'AgentCommission',
    'DistributorCommission',
    'ShopAllCommission',
    'StockBatch',
    'Stock',
    'Price',
    'Metric',
    'Product',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Text(
            "Table Table",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(message ?? "-", style: TextStyle(color: Colors.red.shade800)),
          SizedBox(height: 40),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(isDense: true),
            value: tableChoosen,
            items:
                tables.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: (value) {
              tableChoosen = value;
              setState(() {});
            },
          ),

          SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GradientElevatedButton(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("CANCEL"),
              ),
              GradientElevatedButton(
                onPressed: () async {
                  bool result = await get<SystemViewModel>().genericTable(
                    context: context,
                    table: tableChoosen ?? "-",
                  );

                  if (result) {
                    setState(() {
                      message = "Truncate success";
                    });
                  } else {
                    setState(() {
                      message = "Truncate error";
                    });
                  }
                  await Future.delayed(Duration(seconds: 2));
                },
                child: Text("TRUNCATE"),
              ),
            ],
          ),

          SizedBox(height: 40),

          SizedBox(height: 60),
        ],
      ),
    );
  }
}
