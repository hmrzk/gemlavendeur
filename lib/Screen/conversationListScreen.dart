import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemlavendeur/Helper/Color.dart';
import 'package:gemlavendeur/Helper/Constant.dart';
import 'package:gemlavendeur/Provider/settingProvider.dart';
import 'package:gemlavendeur/Widget/appBar.dart';
import 'package:gemlavendeur/Widget/errorContainer.dart';
import 'package:gemlavendeur/Widget/noNetwork.dart';
import 'package:gemlavendeur/Widget/routes.dart';
import 'package:gemlavendeur/Widget/validation.dart';
import 'package:gemlavendeur/cubits/personalConverstationsCubit.dart';

class ConversationListScreen extends StatefulWidget {
  const ConversationListScreen({Key? key}) : super(key: key);

  @override
  State<ConversationListScreen> createState() => ConversationListScreenState();
}

class ConversationListScreenState extends State<ConversationListScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();

  late AnimationController buttonController;
  late Animation buttonSqueezeanimation;

  @override
  void initState() {
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<PersonalConverstationsCubit>().fetchConversations(
          currentUserId: context.read<SettingProvider>().CUR_USERID ?? '0');
    });
  }

  @override
  void dispose() {
    buttonController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildPersonalConversationsContainer() {
    return BlocBuilder<PersonalConverstationsCubit,
        PersonalConverstationsState>(
      builder: (context, state) {
        if (state is PersonalConverstationsFetchSuccess) {
          if (state.personalConversations.isEmpty) {
            return Center(
              child: Text(
                getTranslated(context, noMessagesKey) ?? noMessagesKey,
                style: const TextStyle(color: primary, fontSize: 16.0),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: state.personalConversations.map(
                (personalChatHistory) {
                  final unreadMessages = personalChatHistory.unreadMsg ?? '';
                  return ListTile(
                    onTap: () async {
                      Routes.navigateToConversationScreen(
                          isGroup: false,
                          context: context,
                          personalChatHistory: personalChatHistory);
                    },
                    tileColor: white,
                    title: Text(personalChatHistory.opponentUsername ?? ''),
                    leading: (personalChatHistory.image ?? '').isEmpty
                        ? const Icon(Icons.person)
                        : SizedBox(
                            height: 25,
                            width: 25,
                            child: CachedNetworkImage(
                              imageUrl: personalChatHistory.image!,
                              errorWidget: (context, url, error) {
                                return const Icon(Icons.person);
                              },
                            )),
                    trailing:
                        (unreadMessages.isNotEmpty && unreadMessages != '0')
                            ? CircleAvatar(
                                radius: 14,
                                child: Text(
                                  personalChatHistory.unreadMsg!,
                                  style: const TextStyle(
                                    color: white,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                  );
                },
              ).toList(),
            ),
          );
        }
        //
        if (state is PersonalConverstationsFetchFailure) {
          if (state.errorMessage == 'No Internet connection') {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: noInternet(context, () {
                  buttonController.forward().then((value) {
                    buttonController.value = 0;
                    context
                        .read<PersonalConverstationsCubit>()
                        .fetchConversations(
                            currentUserId:
                                context.read<SettingProvider>().CUR_USERID ??
                                    '0');
                  });
                }, buttonSqueezeanimation, buttonController),
              ),
            );
          }
          return Center(
            child: ErrorContainer(
                onTapRetry: () {
                  context
                      .read<PersonalConverstationsCubit>()
                      .fetchConversations(
                          currentUserId:
                              context.read<SettingProvider>().CUR_USERID ??
                                  '0');
                },
                errorMessage: state.errorMessage),
          );
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 200),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar('Chat'),
      body: Column(
        children: [
          _buildPersonalConversationsContainer(),
        ],
      ),
    );
  }
}
