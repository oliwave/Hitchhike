import 'package:provider/provider.dart';

import './provider_collection.dart';

final localProviders = <SingleChildCloneableWidget>[
  ChangeNotifierProvider.value(
    value: HomepageProvider(),
  ),
];

final globalProviders = <SingleChildCloneableWidget>[
  ChangeNotifierProvider.value(
    value: RoleProvider(),
  ),
  ChangeNotifierProvider.value(
    value: AuthProvider(),
  ),
  ChangeNotifierProvider.value(
    value: LocationProvider(),
  ),
];
