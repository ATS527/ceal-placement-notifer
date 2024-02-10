import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:placement_notifier/controllers/database_controller.dart';

class EditPlacementScreen extends StatefulWidget {
  const EditPlacementScreen(
      {super.key,
      required this.id,
      required this.companyName,
      required this.jobRole,
      required this.jobDescription,
      required this.applyLink,
      this.logo});

  final String id;
  final String companyName;
  final String jobRole;
  final String jobDescription;
  final String applyLink;
  final String? logo;

  @override
  State<EditPlacementScreen> createState() => _EditPlacementScreenState();
}

class _EditPlacementScreenState extends State<EditPlacementScreen> {
  late TextEditingController _companyNameController;
  late TextEditingController _jobRoleController;
  late TextEditingController _jobDescriptionController;
  late TextEditingController _applyLinkController;

  late bool isLogoPicked = widget.logo != null;
  late String logoUrl = widget.logo ?? "";
  File? logoFile;

  @override
  void initState() {
    _companyNameController = TextEditingController();
    _jobRoleController = TextEditingController();
    _jobDescriptionController = TextEditingController();
    _applyLinkController = TextEditingController();
    _companyNameController.value = TextEditingValue(text: widget.companyName);
    _jobRoleController.value = TextEditingValue(text: widget.jobRole);
    _jobDescriptionController.value =
        TextEditingValue(text: widget.jobDescription);
    _applyLinkController.value = TextEditingValue(text: widget.applyLink);
    logoUrl = widget.logo!;
    super.initState();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _jobRoleController.dispose();
    _jobDescriptionController.dispose();
    _applyLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Placement Notification"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(
                    labelText: "Company Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //image upload
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLogoPicked
                        ? SizedBox(
                            height: 100,
                            width: 100,
                            child: logoFile == null
                                ? Image.network(logoUrl)
                                : Image.file(logoFile!),
                          )
                        : const Text("Pick Logo of the Company"),
                    const SizedBox(
                      width: 20,
                    ),
                    isLogoPicked
                        ? ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isLogoPicked = false;
                              });
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete"),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                File file = File(result.files.single.path!);
                                setState(() {
                                  isLogoPicked = true;
                                  logoFile = file;
                                });
                                // storage.uploadLogo();
                              } else {
                                // User canceled the picker
                              }
                            },
                            child: const Text(
                              "Upload",
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _jobRoleController,
                  decoration: const InputDecoration(
                    labelText: "Job Role",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _jobDescriptionController,
                  decoration: const InputDecoration(
                    labelText: "Job Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _applyLinkController,
                  decoration: const InputDecoration(
                    labelText: "Link for applying",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                //submit button
                SizedBox(
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      db
                          .updateNotification(
                        id: widget.id,
                        companyName: _companyNameController.text,
                        jobRole: _jobRoleController.text,
                        jobDescription: _jobDescriptionController.text,
                        link: _applyLinkController.text,
                        imageFile: logoFile,
                      )
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Notification edited successfully"),
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.send),
                    label: const Text("Edit Placement Notification"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
