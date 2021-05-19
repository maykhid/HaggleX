import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haggle_x/extras/store.dart';
import 'package:haggle_x/screens/create_user.dart';
import 'package:haggle_x/screens/login.dart';
import 'package:haggle_x/services/graphql_config.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:haggle_x/extras/store.dart' as Store;

import 'services/auth.dart';

GraphQlConfig _graphQlConfig = GraphQlConfig();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHiveForFlutter();
  runApp(GraphQLProvider(
    client: _graphQlConfig.client,
    child: CacheProvider(child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth.instance(_graphQlConfig, Status.ignoreVerification),
        ),
        ChangeNotifierProvider.value(value: KeyStore.instance())
      ],
      child: InitBuilders(),
    );
  }
}

class InitBuilders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /**
     * [LayoutBuilder] is necessary when the parent
     * constrains/determines the child size.
     * see [https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html]
     * 
     * [OrientationBuilder] is necessary to render a widget
     * depending on parent widgets orientation.
     *  */
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          // This intializes the Sizer package for usage across the app
          // with contraints from LayoutBuilder and orientation
          // from OrientationBuilder
          SizerUtil().init(constraints, orientation);

          return RootMaterialWidget();
        });
      },
    );
  }
}

class RootMaterialWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          textTheme: TextTheme(),
          inputDecorationTheme: InputDecorationTheme()),
      debugShowCheckedModeBanner: false,
      home: RenderScreen(),
    );
  }
}

class RenderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<KeyStore>(
      // ignore: missing_return
      builder: (context, store, _) {
        switch (store.keyStat) {
          case keyStatus.NoToken:
            return LoginScreen();

          case keyStatus.FoundToken:
            return Home();

          case keyStatus.Inititalizing:
            return LoadingScreen();
        }
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: GestureDetector(
          child: Text(
            'Load Countries',
            style: TextStyle(fontSize: 100.0, color: Colors.red),
          ),
          onTap: () {
            Provider.of<Auth>(context, listen: false).getActiveCountries();
          },
        ),
      ),
    );
  }
}
