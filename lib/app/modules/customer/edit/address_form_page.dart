import 'package:flutter/material.dart';
import 'address_popup_button.dart'; // 위 위젯 import
import 'package:get/get.dart';
class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final TextEditingController _zonecodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _detailAddressController = TextEditingController();
  String address = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주소 입력')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            AddressPopupButton(
              onSelected: (zonecode, roadAddress) {
                setState(() {
                  _zonecodeController.text = zonecode;
                  _addressController.text = roadAddress;

                  address = '$zonecode, $roadAddress';
                });
              },
            ),
            TextField(
              controller: _zonecodeController,
              decoration: const InputDecoration(labelText: '우편번호'),
              readOnly: true,
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: '도로명 주소'),
              readOnly: true,
            ),
            TextField(
              controller: _detailAddressController,
              decoration: const InputDecoration(labelText: '상세 주소'),
            ),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              debugPrint('$_zonecodeController.text, $_addressController.text');
              Get.back(result: address+' '+_detailAddressController.text);
            }, child: Text("주소 저장"))
          ],
        ),
      ),
    );
  }
}
