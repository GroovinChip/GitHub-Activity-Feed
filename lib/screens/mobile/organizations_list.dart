import 'package:flutter/material.dart';
import 'package:github/github.dart';

class OrganizationsList extends StatefulWidget {
  OrganizationsList({
    Key key,
    this.user,
    this.organizations,
  }) : super(key: key);

  final User user;
  final List<Organization> organizations;

  @override
  _OrganizationsListState createState() => _OrganizationsListState();
}

class _OrganizationsListState extends State<OrganizationsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user.login}\'s organizations'),
      ),
      body: ListView.builder(
        itemCount: widget.organizations.length,
        itemBuilder: (context, index) {
          final organization = widget.organizations[index];
          return ListTileTheme(
            textColor: Theme.of(context).colorScheme.onBackground,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(organization.avatarUrl),
              ),
              title: Text(organization.login),
            ),
          );
        },
      ),
    );
  }
}
