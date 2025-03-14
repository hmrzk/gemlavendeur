import 'package:gemlavendeur/Helper/ApiBaseHelper.dart';
import 'package:gemlavendeur/Model/order/consignment_model.dart';
import 'package:gemlavendeur/Widget/api.dart';
import 'package:gemlavendeur/Widget/parameterString.dart';

class GenerateAWBRepository {
  Future<ConsignmentModel> generateAWB({required String shipmentId}) async {
    print("issend------> ");
    var parameter = {
      SHIPMENT_ID: shipmentId,
    };
    try {
      var response =
          await ApiBaseHelper().postAPICall(generateAWBApi, parameter);

      // Validate response
      if (response['error'] == true) {
        throw ApiException(response['message']);
      }

      return ConsignmentModel.fromMap((response['data']));
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }
}
