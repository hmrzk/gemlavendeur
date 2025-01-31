import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemlavendeur/Helper/Constant.dart';
import 'package:gemlavendeur/Model/groupDetails.dart';
import 'package:gemlavendeur/Model/personalChatHistory.dart';
import 'package:gemlavendeur/Model/searchedUser.dart';
import 'package:gemlavendeur/Repository/chatRepository.dart';
import 'package:gemlavendeur/Repository/userRepository.dart';
import 'package:gemlavendeur/Screen/AddPickUpLocation/addPickUpLocation.dart';
import 'package:gemlavendeur/Screen/OrderList/orders_screen.dart';
import 'package:gemlavendeur/Screen/PickUpLocation/PickUpLocationList.dart';
import 'package:gemlavendeur/Screen/conversationListScreen.dart';
import 'package:gemlavendeur/Screen/conversationScreen.dart';
import 'package:gemlavendeur/Screen/createGroupScreen.dart';
import 'package:gemlavendeur/Screen/groupInfo/groupInfoScreen.dart';
import 'package:gemlavendeur/Screen/searchUsersScreen.dart';
import 'package:gemlavendeur/cubits/converstationCubit.dart';
import 'package:gemlavendeur/cubits/createGroupCubit.dart';
import 'package:gemlavendeur/cubits/editGroupCubit.dart';
import 'package:gemlavendeur/cubits/searchUserCubit.dart';
import 'package:gemlavendeur/cubits/sendMessageCubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screen/AddProduct/Add_Product.dart';
import '../Screen/Authentication/SellerRegistration.dart';
import '../Screen/Profile/Profile.dart';
import '../Screen/SalesReport/SalesReport.dart';
import '../Screen/Serach/Search.dart';
import '../main.dart';

// comman Rout For All Screen
class Routes {
  // pop the current page
  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  // simple routes
  static navigateToMyApp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (context.mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => MyApp(sharedPreferences: prefs),
        ),
      );
    }
  }

  static navigateToAddProduct(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const AddProduct(),
      ),
    );
  }

  static navigateToAddPickUpLocation(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const AddPickUpLocation(),
      ),
    );
  }

  static navigateToPickUpLocationList(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const PickUpLocationList(),
      ),
    );
  }

  static navigateToSearch(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const Search(),
      ),
    );
  }

  static navigateToSellerRegister(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SellerRegister(),
      ),
    );
  }

  static navigateToOrderList(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const OrdersScreen(),
      ),
    );
  }

  static navigateToSalesReport(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SalesReport(),
      ),
    );
  }

  static navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  static navigateToConversationListScreen(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ConversationListScreen(
          key: conversationListScreenStateKey,
        ),
      ),
    );
  }

  static navigateToConversationScreen(
      {required BuildContext context,
      PersonalChatHistory? personalChatHistory,
      GroupDetails? groupDetails,
      required bool isGroup}) {
    conversationScreenStateKey = GlobalKey<ConversationScreenState>();
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => ConversationCubit(ChatRepository()),
                  ),
                  BlocProvider(
                      create: (_) => SendMessageCubit(ChatRepository()))
                ],
                child: ConversationScreen(
                    groupDetails: groupDetails,
                    key: conversationScreenStateKey,
                    isGroup: isGroup,
                    personalChatHistory: personalChatHistory))));
  }

  static Future<Map<String, dynamic>?> navigateToSearchUserScreen(
      {required BuildContext context,
      required SearchFor searchFor,
      List<SearchedUser>? users}) {
    return Navigator.push<Map<String, dynamic>?>(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => SearchUserCubit(UserRepository()),
          child: SearchUsersScreen(
            searchedUser: users,
            searchFor: searchFor,
          ),
        ),
      ),
    );
  }

  static navigateToCreateGroupScreen(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SearchUserCubit(UserRepository()),
            ),
            BlocProvider(
              create: (context) => CreateGroupCubit(ChatRepository()),
            ),
          ],
          child: const CreateGroupScreen(),
        ),
      ),
    );
  }

  static Future<GroupDetails?> navigateToGroupInfoScreen(
      {required BuildContext context,
      required GroupDetails groupDetails}) async {
    return Navigator.push<GroupDetails?>(
      context,
      CupertinoPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => EditGroupCubit(ChatRepository()),
          child: GroupInfoScreen(groupDetails: groupDetails),
        ),
      ),
    );
  }
}
