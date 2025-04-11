// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/src/models/freezer_status.dart';
import 'package:frontend/src/services/api_service.dart';
import 'package:frontend/src/utils/helpers.dart';
import 'package:frontend/src/view_models/stock_view_model.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:frontend/src/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UpdateFreezerStatus extends StatefulWidget with GetItStatefulWidgetMixin {
  UpdateFreezerStatus({
    super.key,
    required this.freezer,
    required this.selectedStatus,
  });

  final dynamic freezer;
  final Function(FreezerStatus?) selectedStatus;

  @override
  State<UpdateFreezerStatus> createState() => _UpdateFreezerStatusState();
}

class _UpdateFreezerStatusState extends State<UpdateFreezerStatus>
    with GetItStateMixin {
  bool _isBusy = false;
  bool _isClient = true;
  late FreezerStatus _selectedStatus;
  final List<FreezerStatus> _allStatuses = FreezerStatus.values;
  final TextEditingController _freezerDescController = TextEditingController();

  Future<bool> _handleUpdate() async {
    String? id =
        get<SystemViewModel>().salesId ??
        (get<SystemViewModel>().subAgentId ?? (get<SystemViewModel>().agentId));

    String salesId = id ?? "";

    if (_selectedStatus == FreezerStatus.idle) {
      bool result = await get<StockViewModel>().returnFreezer(
        context: context,
        id: widget.freezer?['id'] ?? "",
      );

      if (result) {
        if (_isClient) {
          await get<StockViewModel>().getShopsBySales(
            context: context,
            salesId: salesId,
          );
        } else {
          await get<StockViewModel>().getAllShops(context: context);
        }
        await get<StockViewModel>().getAllFrezer(context);
        return true;
      } else {
        return false;
      }
    } else {
      bool result = await ApiService().updateFreezerStatus(
        context: context,
        id: widget.freezer?['id'] ?? "",
        status: _selectedStatus.name,
        description: _freezerDescController.text,
      );

      if (result) {
        if (_isClient) {
          await get<StockViewModel>().getShopsBySales(
            context: context,
            salesId: salesId,
          );
        } else {
          await get<StockViewModel>().getAllShops(context: context);
        }
        await get<StockViewModel>().getAllFrezer(context);
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _isClient = (get<SystemViewModel>().level ?? 0) < 4;
    _selectedStatus = freezerStatusFromString(widget.freezer?['status']);
    _freezerDescController.text = widget.freezer?['description'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              "Freezer Status",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              "${widget.freezer['name']} (${widget.freezer['serialNumber']})",
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              freezerStatusFromString(widget.freezer['status']).displayName,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade600,
              ),
            ),
            Divider(),

            // Generate RadioListTiles dynamically (logic remains the same)
            ..._allStatuses.map((status) {
              return RadioListTile<FreezerStatus>(
                dense: true,
                radioScaleFactor: 0.8,
                activeColor: Colors.blue.shade700,
                title: Text(status.displayName),
                value: status,
                groupValue:
                    _selectedStatus, // Uses the initialized _selectedStatus
                onChanged: (FreezerStatus? value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              );
            }),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _freezerDescController,
                maxLines: 2,
                minLines: 1,
                decoration: InputDecoration(
                  labelText: "Keterangan",
                  isDense: true,
                ),
              ),
            ),
            SizedBox(height: 30),

            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isBusy)
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GradientElevatedButton(
                      buttonHeight: 30,
                      onPressed: () {
                        setState(() {
                          _selectedStatus = freezerStatusFromString(
                            widget.freezer['status'],
                          );
                        });
                        Navigator.pop(context, null);
                      },
                      child: Text(
                        "Batal",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GradientElevatedButton(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade300, Colors.green.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      buttonHeight: 30,
                      onPressed: () async {
                        setState(() => _isBusy = true);
                        bool response = await _handleUpdate();
                        setState(() => _isBusy = false);

                        if (response) {
                          widget.selectedStatus(_selectedStatus);
                          Navigator.pop(context, true);
                        } else {
                          widget.selectedStatus(null);
                          Navigator.pop(context, false);
                        }
                      },
                      child: Text(
                        "Ganti",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
