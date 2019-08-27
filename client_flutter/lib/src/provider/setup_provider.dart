import 'package:provider/provider.dart';

import './provider_collection.dart';

final localProviders = <SingleChildCloneableWidget>[
  ChangeNotifierProvider.value(
    value: HomepageProvider(),
  ),
  ChangeNotifierProvider.value(
    value: FavoriteRoutesProvider(),
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
  ChangeNotifierProvider.value(
    value: BulletinProvider(),
  ),
  ChangeNotifierProvider.value(
    value: CloudMessageProvider(),
  ),
];
