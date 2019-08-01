import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_collection.dart';

class TestingInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomepageProvider>(
      context,
      listen: false,
    );

    return Align(
      alignment: Alignment(1, -0.6),
      child: IconButton(
        icon: Icon(Icons.info),
        onPressed: () => _showInfo(provider),
      ),
    );
  }

  _showInfo(HomepageProvider provider) {
    provider.changeHasInfo(); 
  }
}
