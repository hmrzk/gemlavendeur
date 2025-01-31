import 'package:gemlavendeur/Helper/ApiBaseHelper.dart';
import 'package:gemlavendeur/Model/searchedUser.dart';
import 'package:gemlavendeur/Widget/api.dart';

class UserRepository {
  Future<List<SearchedUser>> searchUser({required String search}) async {
    try {
      final result =
          await ApiBaseHelper().postAPICall(searchUserApi, {'search': search});
      if (result['error']) {
        throw ApiException(result['message']);
      }
      return ((result['data'] ?? []) as List)
          .map((searchedUser) =>
              SearchedUser.fromJson(Map.from(searchedUser ?? {})))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
