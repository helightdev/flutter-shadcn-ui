// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:example/common/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  State<SidebarPage> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  final ShadSidebarController controller = ShadSidebarController();

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBarTitle: 'Sidebar',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadSidebar(
              controller: controller,
              content: [
                ShadSidebarGroup(
                  items: [
                    ShadSidebarMenuItem(
                      icon: Icon(LucideIcons.house),
                      child: Text("Home"),
                    ),
                    ShadSidebarMenuItem(
                      icon: Icon(LucideIcons.inbox),
                      child: Text("Inbox"),
                    ),
                  ],
                  child: Text("Group"),
                ),
                ShadSidebarMenuSub(
                  items: [
                    ShadSidebarMenuItem(
                      child: Text("Item 1"),
                      trailing: Icon(LucideIcons.ellipsis),
                      showTrailingOnHover: true,
                    ),
                    ShadSidebarMenuItem(
                      child: Text("Item 2"),
                      trailing: Icon(LucideIcons.ellipsis),
                      showTrailingOnHover: true,
                    ),
                  ],
                  icon: Icon(LucideIcons.boxes),
                  trailing: Icon(LucideIcons.chevronRight),
                  child: Text("Items"),
                ),
                ShadSidebarMenuItem(
                  icon: Icon(LucideIcons.car),
                  child: Text("Delivery"),
                ),
              ],
            ),
            ShadButton(
              onPressed: () {
                controller.value = !controller.value;
              },
              child: Text("Toggle Sidebar"),
            ),
          ],
        ),
      ],
    );
  }
}
