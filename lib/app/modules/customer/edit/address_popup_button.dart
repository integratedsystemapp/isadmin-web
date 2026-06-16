import 'dart:html' as html;
import 'package:flutter/material.dart';

class AddressPopupButton extends StatelessWidget {
  final void Function(String zonecode, String roadAddress) onSelected;

  const AddressPopupButton({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        html.window.open(
          '/kakao_address_popup.html',
          'kakaoPostcodePopup',
          'width=500,height=600,scrollbars=yes',
        );

        html.window.onMessage.first.then((event) {
          final data = event.data;
          if (data is Map) {
            final zc = data['zonecode'];
            final addr = data['roadAddress'];
            onSelected(zc ?? '', addr ?? '');
          }
        });
      },
      child: const Text('주소 검색'),
    );
  }
}
