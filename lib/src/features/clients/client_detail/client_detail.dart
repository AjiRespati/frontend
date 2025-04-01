import 'package:flutter/material.dart';
import 'package:frontend/src/features/clients/client_detail/client_detail_desktop.dart';
import 'package:frontend/src/features/clients/client_detail/client_detail_mobile.dart';
import 'package:frontend/src/utils/responsive_layout.dart';

class ClientDetail extends StatefulWidget {
  const ClientDetail({required this.item, super.key});
  final dynamic item;

  @override
  State<ClientDetail> createState() => _ClientDetailState();
}

class _ClientDetailState extends State<ClientDetail> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: ClientDetailDesktop(),
      mobileLayout: ClientDetailMobile(item: widget.item),
    );
  }
}
