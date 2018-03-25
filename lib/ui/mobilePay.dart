// Get battery level.
//String _mobilePayStatus = 'Ikke betalt.';
//
//Future<Null> _getMobilePayStatus() async {
//  String betalt;
//  try {
//    final String result = await platform.invokeMethod('getMobilePayStatus', {"price": 33});
//    betalt = 'Betalt $result % .';
//  } catch (e) {
//    betalt = "Fejlede betaling: '${e.message}'.";
//  }
//
//  setState(() {
//    _mobilePayStatus = betalt;
//  });
//}