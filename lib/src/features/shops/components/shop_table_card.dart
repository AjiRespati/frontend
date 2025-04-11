// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';

import 'package:get_it_mixin/get_it_mixin.dart';

class ShopTableCard extends StatefulWidget with GetItStatefulWidgetMixin {
  ShopTableCard({
    super.key,
    required this.isMobile,
    required this.isClient,
    required this.shop,
  });

  final Map<String, dynamic> shop;
  final bool isMobile;
  final bool isClient;

  @override
  State<ShopTableCard> createState() => _ShopTableCardState();
}

class _ShopTableCardState extends State<ShopTableCard> with GetItStateMixin {
  bool _isBroken = false;

  void _setup() {
    List<bool> brokenFreezer = [];
    for (var i = 0; i < (widget.shop['Refrigerators'] ?? []).length; i++) {
      var item = widget.shop['Refrigerators'][i];
      if (item['status'] != null &&
          (item['status'] == 'broken' || item['status'] == 'repairing')) {
        brokenFreezer.add(true);
      }

      _isBroken = brokenFreezer.isNotEmpty;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((StockViewModel x) => x.reloadBuy);
    _setup();
    return ClipRect(
      child: Banner(
        message: _isBroken ? 'Cek !' : "",
        textStyle: TextStyle(
          color: Colors.red[800],
          fontWeight: FontWeight.w900,
          fontSize: 16,
        ),
        location: BannerLocation.topEnd,
        color:
            _isBroken
                ? const Color.fromARGB(65, 240, 105, 148)
                : Colors.transparent,
        shadow: BoxShadow(
          color:
              _isBroken
                  ? Color.fromARGB(65, 240, 105, 148)
                  : Colors.transparent,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                shopsDetailRoute,
                arguments: widget.shop,
              );
            },
            child: SizedBox(
              height: 130,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.shop['name'] ?? " N/A",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                maxLines: 2,
                                widget.shop['address'] ?? " N/A",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              widget.shop['phone'] ?? " N/A",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              (widget.shop['status'] ?? " N/A").toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: statusColor(
                                  widget.shop['status'] ?? " N/A",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        if (widget.shop['Salesman'] != null)
                          Row(children: [Text("Sales:")]),
                        if (widget.shop['Salesman'] != null)
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                widget.shop['Salesman']['name'],
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        if (widget.shop['SubAgent'] != null)
                          Row(children: [Text("Sub Agent:")]),
                        if (widget.shop['SubAgent'] != null)
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                widget.shop['SubAgent']['name'],
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        if (widget.shop['Agent'] != null)
                          Row(children: [Text("Agent:")]),
                        if (widget.shop['Agent'] != null)
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Text(
                                widget.shop['Agent']['name'],
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        Row(children: [Text("Freezer:")]),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                            height: 55,
                            child: ListView.builder(
                              itemCount:
                                  widget.shop['Refrigerators'] == null
                                      ? 0
                                      : widget.shop['Refrigerators'].length,
                              itemBuilder: (context, index) {
                                var item = widget.shop['Refrigerators'][index];
                                return Row(
                                  key: ValueKey(index + 8000),
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "${item['name']} (${item['serialNumber']})",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            shopsDetailRoute,
                            arguments: widget.shop,
                          );
                        },
                        icon: Icon(Icons.chevron_right_outlined, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case 'idle':
        return Colors.amberAccent.shade700;
      case 'active':
        return Colors.green.shade700;
      case 'inactive':
        return Colors.red.shade400;
      case 'broken':
        return Colors.red.shade700;
      case 'repairing':
        return Colors.red.shade400;
      case 'wasted':
        return Colors.blueGrey.shade900;
      default:
        return Colors.black;
    }
  }
}
