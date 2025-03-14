import 'package:gemlavendeur/Helper/ApiBaseHelper.dart';
import 'package:gemlavendeur/Model/delivery_boy_model.dart';
import 'package:gemlavendeur/Widget/api.dart';
import 'package:gemlavendeur/Widget/parameterString.dart';
import 'package:gemlavendeur/Widget/sharedPreferances.dart';

typedef DeliveryBoyResult = ({List<DeliveryBoy> deliveryBoys, String total});

class DeliveryboyRepository {
  Future<DeliveryBoyResult> getDeliveryBoys(
      {String? search, required String offset}) async {
    Map<String, String> parameter = {
      if (search != null) "search": search,
      "seller_id": (await getPrefrence(Id)) ?? '',
      'offset': offset
    };
    var response =
        await ApiBaseHelper().postAPICall(getDeliveryBoysApi, parameter);
    List<DeliveryBoy> deliveryBoys = (response['data'] as List)
        .map(
          (e) => DeliveryBoy.fromMap(e),
        )
        .toList();

    return (deliveryBoys: deliveryBoys, total: response['total'].toString());
  }
}
