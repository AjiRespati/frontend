import 'package:flutter/material.dart';
import 'package:frontend/src/routes/route_names.dart';
import 'package:frontend/src/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MobileNavbar extends StatelessWidget with GetItMixin {
  MobileNavbar({super.key});
  @override
  Widget build(BuildContext context) {
    int? level = watchOnly((SystemViewModel x) => x.level);
    switch (level) {
      case 6:
        return NavigationBar(
          onDestinationSelected: (value) {
            get<SystemViewModel>().currentPageIndex = value;
            switch (value) {
              case 0:
                Navigator.pushNamed(context, dashboardRoute);
                break;
              case 1:
                Navigator.pushNamed(context, transactionsRoute);
                break;
              case 2:
                Navigator.pushNamed(context, productsRoute, arguments: true);
                break;
              default:
                Navigator.pushNamed(context, settingsRoute);
                break;
            }
          },
          selectedIndex: get<SystemViewModel>().currentPageIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home, color: Colors.blueAccent.shade700),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.sell_outlined),
              selectedIcon: Icon(
                Icons.sell_outlined,
                color: Colors.blueAccent.shade700,
              ),
              label: "Pembelian",
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_checkout_rounded),
              selectedIcon: Icon(
                Icons.shopping_cart_checkout_rounded,
                color: Colors.blueAccent.shade700,
              ),
              label: "Stock",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.blueAccent.shade700,
              ),
              label: "Setting",
            ),
          ],
        );

      case 5:
        return NavigationBar(
          onDestinationSelected: (value) {
            get<SystemViewModel>().currentPageIndex = value;
            switch (value) {
              case 0:
                Navigator.pushNamed(context, dashboardRoute);
                break;
              case 1:
                Navigator.pushNamed(context, transactionsRoute);
                break;
              case 2:
                Navigator.pushNamed(context, stockRoute);
                break;
              case 3:
                Navigator.pushNamed(context, clientsRoute);
                break;
              default:
                Navigator.pushNamed(context, settingsRoute);
              //   break;
              // default:
              //   Navigator.pushNamed(context, dashboardRoute);
            }
          },
          selectedIndex: get<SystemViewModel>().currentPageIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home, color: Colors.blueAccent.shade700),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.sell_outlined),
              selectedIcon: Icon(
                Icons.sell_outlined,
                color: Colors.blueAccent.shade700,
              ),
              label: "Pembelian",
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_checkout_rounded),
              selectedIcon: Icon(
                Icons.shopping_cart_checkout_rounded,
                color: Colors.blueAccent.shade700,
              ),
              label: "Stock",
            ),
            NavigationDestination(
              icon: Icon(Icons.store_rounded),
              selectedIcon: Icon(
                Icons.store_rounded,
                color: Colors.blueAccent.shade700,
              ),
              label: "Clients",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.blueAccent.shade700,
              ),
              label: "Setting",
            ),
          ],
        );

      case 4:
        return NavigationBar(
          onDestinationSelected: (value) {
            get<SystemViewModel>().currentPageIndex = value;
            switch (value) {
              case 0:
                Navigator.pushNamed(context, dashboardRoute);
                break;
              case 1:
                Navigator.pushNamed(context, transactionsRoute);
                break;
              case 2:
                Navigator.pushNamed(context, stockRoute);
                break;
              case 3:
                Navigator.pushNamed(context, clientsRoute);
                break;
              default:
                Navigator.pushNamed(context, settingsRoute);
              //   break;
              // default:
              //   Navigator.pushNamed(context, dashboardRoute);
            }
          },
          selectedIndex: get<SystemViewModel>().currentPageIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home, color: Colors.blueAccent.shade700),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.sell_outlined),
              selectedIcon: Icon(
                Icons.sell_outlined,
                color: Colors.blueAccent.shade700,
              ),
              label: "Pembelian",
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_checkout_rounded),
              selectedIcon: Icon(
                Icons.shopping_cart_checkout_rounded,
                color: Colors.blueAccent.shade700,
              ),
              label: "Stock",
            ),
            NavigationDestination(
              icon: Icon(Icons.store_rounded),
              selectedIcon: Icon(
                Icons.store_rounded,
                color: Colors.blueAccent.shade700,
              ),
              label: "Clients",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.blueAccent.shade700,
              ),
              label: "Setting",
            ),
          ],
        );

      case 0:
        return NavigationBar(
          onDestinationSelected: (value) {
            get<SystemViewModel>().currentPageIndex = value;
            switch (value) {
              case 0:
                Navigator.pushNamed(context, dashboardRoute);
                break;
              case 1:
                Navigator.pushNamed(context, clientsRoute);
                break;
              default:
                Navigator.pushNamed(context, settingsRoute);
                break;
            }
          },
          selectedIndex: get<SystemViewModel>().currentPageIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home, color: Colors.blueAccent.shade700),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.store_rounded),
              selectedIcon: Icon(
                Icons.store_rounded,
                color: Colors.blueAccent.shade700,
              ),
              label: "Clients",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.blueAccent.shade700,
              ),
              label: "Setting",
            ),
          ],
        );

      default:
        return NavigationBar(
          onDestinationSelected: (value) {
            get<SystemViewModel>().currentPageIndex = value;
            switch (value) {
              case 0:
                Navigator.pushNamed(context, dashboardRoute);
                break;
              case 1:
                Navigator.pushNamed(context, transactionsRoute);
                break;
              case 2:
                Navigator.pushNamed(context, productsRoute, arguments: true);
                break;
              case 3:
                Navigator.pushNamed(context, shopsRoute, arguments: null);
                break;
              default:
                Navigator.pushNamed(context, settingsRoute);
              //   break;
              // default:
              //   Navigator.pushNamed(context, dashboardRoute);
            }
          },
          selectedIndex: get<SystemViewModel>().currentPageIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home, color: Colors.blueAccent.shade700),
              label: "Dashboard",
            ),
            NavigationDestination(
              icon: Icon(Icons.sell_outlined),
              selectedIcon: Icon(
                Icons.sell_outlined,
                color: Colors.blueAccent.shade700,
              ),
              label: "Pembelian",
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_checkout_rounded),
              selectedIcon: Icon(
                Icons.shopping_cart_checkout_rounded,
                color: Colors.blueAccent.shade700,
              ),
              label: "Stock",
            ),
            NavigationDestination(
              icon: Icon(Icons.store_rounded),
              selectedIcon: Icon(
                Icons.store_rounded,
                color: Colors.blueAccent.shade700,
              ),
              label: "Toko",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(
                Icons.settings,
                color: Colors.blueAccent.shade700,
              ),
              label: "Setting",
            ),
          ],
        );
    }
  }
}
