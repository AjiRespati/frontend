import 'package:flutter/material.dart';
import '../routes/route_names.dart';
import 'side_bar.dart';

class PageContainer extends StatefulWidget {
  const PageContainer({
    required this.showMenubutton,
    required this.mainSection,
    this.customSideBar,
    this.infoSection,
    this.setSidebarExpanding,
    super.key,
  });

  final Widget mainSection;
  final Widget? customSideBar;
  final Widget? infoSection;
  final bool showMenubutton;
  final bool? setSidebarExpanding;

  @override
  State<PageContainer> createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  bool sideBarExpanding = false;

  void onTapMenu(String? menuTitle) {
    setState(() {
      sideBarExpanding = !sideBarExpanding;
    });

    switch (menuTitle) {
      case "Dashboard":
        Navigator.pushNamed(context, dashboardRoute);
        break;
      case "Products":
        Navigator.pushNamed(context, productsRoute);
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    sideBarExpanding = widget.setSidebarExpanding ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// ✅ Main and Info section
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: Durations.short1,
              width: sideBarExpanding ? 300 : 0,
            ),
            Expanded(child: SingleChildScrollView(child: widget.mainSection)),
            SingleChildScrollView(child: widget.infoSection),
          ],
        ),

        /// ✅ Sidebar Component
        Positioned(
          left: -295,
          child: Row(
            children: [
              AnimatedContainer(
                duration: Durations.short1,
                width: sideBarExpanding ? 300 : 0,
              ),
              widget.customSideBar != null
                  ? widget.customSideBar!
                  : SideBar(
                    onTapMenu: ({menuTitle}) {
                      onTapMenu(menuTitle);
                    },
                  ),

              /// ✅ Middle button show/hide menu
              widget.showMenubutton
                  ? InkWell(
                    onTap: () {
                      setState(() {
                        sideBarExpanding = !sideBarExpanding;
                      });
                    },
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade200,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          size: 26,
                          color: Colors.blue[700],
                          sideBarExpanding
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                        ),
                      ),
                    ),
                  )
                  : const SizedBox(),
            ],
          ),
        ),

        /// ✅ Menu burger icon
        sideBarExpanding
            ? const SizedBox()
            : Padding(
              padding: const EdgeInsets.only(left: 22, top: 20),
              child: InkWell(
                onTap: () {
                  setState(() {
                    sideBarExpanding = !sideBarExpanding;
                  });
                },
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Icon(
                  Icons.menu_rounded,
                  size: 30,
                  color: Colors.blue[700],
                ),
              ),
            ),
      ],
    );
  }
}
