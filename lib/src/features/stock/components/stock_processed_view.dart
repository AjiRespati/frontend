import 'package:flutter/material.dart';
import 'package:frontend/src/features/stock/components/stock_client_card.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class StockProcessedView extends StatefulWidget with GetItStatefulWidgetMixin {
  StockProcessedView({super.key});

  @override
  State<StockProcessedView> createState() => _StockProcessedViewState();
}

class _StockProcessedViewState extends State<StockProcessedView>
    with GetItStateMixin {
  List<String> _clients = [];
  String? _client;
  List<String> _names = [];
  String? _nameChoosen;
  String? _idChoosen;

  Future<void> _setup() async {
    _clients = get<StockViewModel>().clientProducts;
    await Future.delayed(Durations.short4);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDatePicker(
                context,
                "From: ",
                get<StockViewModel>().dateFromFilter,
                (date) {
                  get<StockViewModel>().dateFromFilter = date;
                },
              ),
              SizedBox(width: 4),
              _buildDatePicker(
                context,
                "To: ",
                get<StockViewModel>().dateToFilter,
                (date) {
                  get<StockViewModel>().dateToFilter = date;
                },
              ),
              SizedBox(width: 4),

              GradientElevatedButton(
                // inactiveDelay: Duration.zero,
                buttonHeight: 34,
                onPressed: () {
                  get<StockViewModel>().totalOnProgress = 0.0;
                  get<StockViewModel>().getStockTable(
                    context: context,
                    status: 'created',
                    isClient: (get<SystemViewModel>().level ?? 0) < 4,
                    salesId: _client == "salesman" ? _idChoosen : null,
                    agentId: _client == "subAgent" ? _idChoosen : null,
                    subAgentId: _client == "agent" ? _idChoosen : null,
                  );
                },
                child: Icon(Icons.search, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(isDense: true),
                  value:
                      _client, // watchOnly((StockViewModel x) => x.clientProduct),
                  items:
                      _clients.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  // get<StockViewModel>().clientProducts.map((item) {
                  //   return DropdownMenuItem<String>(
                  //     value: item,
                  //     child: Text(item),
                  //   );
                  // }).toList(),
                  onChanged: (value) async {
                    get<StockViewModel>().salesChoosen = null;
                    get<StockViewModel>().subAgentChoosen = null;
                    get<StockViewModel>().agentChoosen = null;
                    get<StockViewModel>().clientProduct = value;
                    _nameChoosen = null;
                    _client = value;

                    switch (value) {
                      case 'salesman':
                        _names = get<StockViewModel>().salesmanNames;
                        break;
                      case 'subAgent':
                        _names = get<StockViewModel>().subAgentNames;
                        break;
                      case 'agent':
                        _names = get<StockViewModel>().agentNames;
                        break;
                      default:
                        _names = [];
                    }
                    await Future.delayed(Durations.short4);
                    setState(() {});
                  },
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(isDense: true),
                  value: _nameChoosen,
                  // (_client == "salesman")
                  //     ? watchOnly(
                  //       (StockViewModel x) => x.salesChoosen,
                  //     ) // get<StockViewModel>().salesChoosen
                  //     : (_client == 'subAgent')
                  //     ? watchOnly((StockViewModel x) => x.subAgentChoosen)
                  //     : watchOnly((StockViewModel x) => x.agentChoosen),
                  items:
                      _names.map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  onChanged: (value) async {
                    (_client == "salesman")
                        ? get<StockViewModel>().salesChoosen = value
                        : (_client == 'subAgent')
                        ? get<StockViewModel>().subAgentChoosen = value
                        : get<StockViewModel>().agentChoosen = value;
                    _nameChoosen = value;
                    _idChoosen = generateIdChoosen(_client, _nameChoosen);

                    await Future.delayed(Durations.short4);
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),

        Divider(),

        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Total Belum Dibayar:  "),
              Text(
                formatCurrency(get<StockViewModel>().totalOnProgress),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.red.shade700,
                ),
              ),
              SizedBox(width: 13),
            ],
          ),
        ),
        watchOnly((StockViewModel x) => x.stockOnProgressTable).isEmpty
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                  child: Text(
                    "Tidak ada stock yang perlu diproses didalam filter tanggal.",
                  ),
                ),
              ],
            )
            : Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: get<StockViewModel>().stockOnProgressTable.length,
                  itemBuilder: (context, index) {
                    // int level = get<SystemViewModel>().level ?? 0;
                    Map<String, dynamic> stock =
                        get<StockViewModel>().stockOnProgressTable[index];
                    return StockClientCard(
                      stockStatus: 'created',
                      isMobile: true,
                      stock: stock,
                    );
                    // if (level > 3) {
                    //   return StockTableCard(
                    //     stockStatus: 'created',
                    //     isMobile: true,
                    //     stock: stock,
                    //   );
                    // } else {
                    //   return StockClientCard(
                    //     stockStatus: 'created',
                    //     isMobile: true,
                    //     stock: stock,
                    //   );
                    // }
                  },
                ),
              ),
            ),
      ],
    );
  }

  String? generateIdChoosen(String? client, String? nameChoosen) {
    switch (client) {
      case 'salesman':
        var user =
            get<StockViewModel>().salesmen
                .where((el) => el['name'] == nameChoosen)
                .toList();
        return user.first['id'];
      case 'subAgent':
        var user =
            get<StockViewModel>().subAgents
                .where((el) => el['name'] == nameChoosen)
                .toList();
        return user.first['id'];
      default:
        var user =
            get<StockViewModel>().agents
                .where((el) => el['name'] == nameChoosen)
                .toList();
        return user.first['id'];
    }

    return "";
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected,
  ) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: () async {
          DateTime? pickedDate = await showCustomDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
          );
          // );
          if (pickedDate != null) onDateSelected(pickedDate);
        },
        child: Text(
          label + (selectedDate?.toLocal() ?? "").toString().split(' ')[0],
        ),
      ),
    );
  }
}
