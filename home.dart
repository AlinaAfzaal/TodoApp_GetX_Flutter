import 'package:flutter/material.dart';
import 'package:todo_app_ii/providers/home_page_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final Color mainColor = const Color(0xFF0AB6AB);
  final TextEditingController textEditingController = TextEditingController();
  final controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {

    return
    GetBuilder<HomePageController>(
        builder: (_){
          return Scaffold(
                appBar: AppBar(
                  backgroundColor: mainColor,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () async {
                        await showMenu(
                          context: context,
                          position: const RelativeRect.fromLTRB(
                              double.infinity, 90, 0, double.infinity),

                          items: const [
                            PopupMenuItem(
                              value: 0,
                              child: Text('Show All Items'),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: Text('Show Incomplete Items'),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Text('Show Complete Items'),
                            ),
                          ],
                        ).then((value) {
                          if (value != null) {

                            controller.showItems = value;
                            controller.getCurrentList();
                          }
                        });
                      },
                    ),
                  ],
                  title: const Text(
                    'ToDo List', style: TextStyle(fontWeight: FontWeight.bold),),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(30.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 8.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.getFormattedDate(),
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                body: Container(
                  padding: const EdgeInsets.only(top: 15),
                  color: Colors.black,
                  child: ListView.builder(

                    itemCount: controller.currentList.length,
                    itemBuilder: (context, index) {

                      return GestureDetector(
                          onTap: () {
                            controller.toggleCheckbox(index);
                          },
                          child: Slidable(
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 1,
                                  onPressed: (BuildContext context) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Edit ToDo Item'),
                                            content: TextFormField(
                                              initialValue: controller
                                                  .currentList[index].title,
                                              onChanged: (value) {
                                                controller.newValue = value;
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Cancel', style: TextStyle(
                                                    color: Colors.black54),),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  controller.editTodoItem(index);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Edit'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white54,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                                SlidableAction(
                                  flex: 1,
                                  onPressed: (BuildContext context) {
                                    controller.deleteTodoItem(index);
                                  },
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white54,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child:
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              decoration: const BoxDecoration(
                                  color: Color(0xFF201F1F),
                                  borderRadius: BorderRadius.all(Radius.circular(8))
                              ),
                              child: ListTile(
                                  leading: Checkbox(
                                    value: controller.currentList[index].isCompleted,
                                    onChanged: (value) {
                                      controller.toggleCheckbox(index);
                                    },
                                  ),
                                  title: Text(
                                    controller.currentList[index].title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: controller.currentList[index]
                                          .isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  subtitle: controller.currentList[index].reminder !=
                                      null ? Text(
                                    DateFormat('MMM d, yyyy HH:mm').format(controller
                                        .currentList[index].reminder ?? DateTime
                                        .now()),
                                    style: TextStyle(
                                      color: mainColor,
                                    ),
                                  ) : null

                              ),
                            ),
                          ));
                    },
                  ),
                ),
                floatingActionButton: FloatingActionButton(

                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Add ToDo Item'),
                            content: SizedBox(
                              height: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: TextFormField(
                                      controller: textEditingController,
                                      decoration: const InputDecoration(
                                          hintText: 'Enter ToDo Item'),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        controller.reminder = await showOmniDateTimePicker
                                          (context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2024),
                                          lastDate: DateTime(2026),
                                        );
                                      }, child: Text(controller.reminder == null
                                      ? "Set Alarms"
                                      : controller.reminder.toString())),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Cancel', style: TextStyle(color: Colors.black54),),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.addTodoItem(textEditingController.text);

                                  Navigator.pop(context);
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        });
                  },
                  // backgroundColor: mainColor,

                  child: const Icon(Icons.add, color: Colors.black,),

                )


            );
        }
    );
  }


}
