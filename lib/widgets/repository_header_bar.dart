import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RepositoryHeaderBar extends StatelessWidget {
  const RepositoryHeaderBar({
    Key key,
    @required this.repository,
    @required TabController tabController,
  })  : _tabController = tabController,
        super(key: key);

  final Repository repository;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(repository.description ?? 'no description'),
                ],
              ),
              SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.50),
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MdiIcons.sourceBranch, size: 14),
                      SizedBox(width: 8),
                      Text(
                        repository.defaultBranch,
                        style: GoogleFonts.firaCode(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: [
            Tab(text: 'Readme'),
            Tab(text: 'Activity'),
          ],
        ),
      ],
    );
  }
}
