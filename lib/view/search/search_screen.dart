import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/user_controller.dart';
import 'package:snapverese/view/profile/profile_screen.dart';
import 'package:snapverese/widgets/common.dart';
import 'package:snapverese/widgets/search_screen_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserController>(context,listen: false).fetchAllUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customText("SNAPvERSE", 24, fontWeight: FontWeight.w500),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              customSearchBar('Search...',searchController,_handleSearch,_handleSearch,),
              Gap(10),
              Divider(),
              Gap(10),
              Expanded(
                child: Consumer<UserController>(
                  builder: (context, userController, _) {
                    if (userController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final usersToShow = userController.searchResults.isNotEmpty
                      ? userController.searchResults
                      : userController.allUsers;

                    if (usersToShow.isEmpty) {
                      return const Center(child: Text('No users found'));
                    }

                    return ListView.builder(
                      itemCount: usersToShow.length,
                      itemBuilder: (context, index) {
                        final user = usersToShow[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: user.profileImage != null
                                  ? NetworkImage(user.profileImage!)
                                  : const AssetImage('assets/images/profile.png') as ImageProvider,
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: user)));
                            },
                            title: Text(user.name),
                            subtitle: Text(user.bio ?? ''),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _handleSearch() {
    final query = searchController.text.trim();
    final userController = Provider.of<UserController>(context,listen: false);
    if (query.isNotEmpty) {
      userController.searchUsers(query);
    }else{
      userController.clearSearch();
    }
  }
}
