import 'package:flutter/material.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';

class ClientContentDetail extends StatelessWidget {
  const ClientContentDetail({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            item['Stocks'][0]['shopName'],
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          Text(formatDateStringHM(item['createdAt'])),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Komisi: "),
              SizedBox(width: 5),
              Text(
                formatCurrency(item['totalSalesShareSum']),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: item['Stocks'].length,
            itemBuilder: (context, index) {
              var stock = item['Stocks'][index];
              print(stock);
              return Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      stock['productName'],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(stock['amount'].toString()),
                  Expanded(child: Text(stock['metricType'])),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(formatCurrency(stock['totalSalesShare'])),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GradientElevatedButton(
                buttonHeight: 30,
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
