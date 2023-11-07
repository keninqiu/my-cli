import './abi.dart';
import './call.dart';
import 'dart:convert';
import 'dart:io';
import 'package:convert/convert.dart';
import 'dart:typed_data';

Uint8List hexToUint8List(String hex) {
  if (hex.length % 2 != 0) {
    throw 'Odd number of hex digits';
  }
  var l = hex.length ~/ 2;
  var result = Uint8List(l);
  for (var i = 0; i < l; ++i) {
    var x = int.parse(hex.substring(2 * i, 2 * (i + 1)), radix: 16);
    if (x.isNaN) {
      throw 'Expected hex string';
    }
    result[i] = x;
  }
  return result;
}

int calculate() {
  var abi_file = File('./lib/test_abi/MULTISIG.json');

  print(jsonDecode(abi_file.readAsStringSync()));
  var abi = ContractABI.fromJson(jsonDecode(abi_file.readAsStringSync()));

  var signatures = hexToUint8List('54563334554424');
  var data = hexToUint8List('44523432');
  print(signatures);
  print(data);
  var call = ContractCall('execTransaction')
    ..setCallParam('to', '8c4962a9bd5abf2db2282f870ddb26d99bee8bfd')
    ..setCallParam('value', BigInt.from(0))
    ..setCallParam('data', data)
    ..setCallParam('operation',
        0) //0000000000000000000000000000000000000000000000000000000000000000
    ..setCallParam('safeTxGas',
        0) //0000000000000000000000000000000000000000000000000000000000000000
    ..setCallParam('baseGas',
        0) //0000000000000000000000000000000000000000000000000000000000000000
    ..setCallParam('gasPrice',
        0) //0000000000000000000000000000000000000000000000000000000000000000
    ..setCallParam('gasToken',
        '0000000000000000000000000000000000000000') //0000000000000000000000000000000000000000000000000000000000000000
    ..setCallParam('refundReceiver', '0000000000000000000000000000000000000000')
    ..setCallParam('signatures',
        signatures); //0000000000000000000000000000000000000000000000000000000000000000;

// Step3.
// Encode call
  print(call);
  print(abi);
  var composed = abi.composeCall(call);
  if (composed != null) {
    print(hex.encode(composed));
  }

  return 6 * 7;
}
