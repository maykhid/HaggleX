import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haggle_x/extras/store.dart';
import 'package:haggle_x/extras/widgets.dart';
import 'package:haggle_x/screens/create_user.dart';
import 'package:haggle_x/screens/login.dart';
import 'package:haggle_x/services/graphql_config.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:haggle_x/extras/store.dart' as Store;

import 'extras/app_colors.dart';
import 'services/auth.dart';

GraphQlConfig _graphQlConfig = GraphQlConfig();

getLinkSvg(String url) {
  final networkSvg = SvgPicture.network(url);
  return networkSvg;
}

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

class ListCountriesScreen extends StatefulWidget {
  @override
  _ListCountriesScreenState createState() => _ListCountriesScreenState();
}

class _ListCountriesScreenState extends State<ListCountriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.purple,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 2.0.h, right: 2.0.h, top: 2.0.h),
            child: Column(
              children: [
                // search
                SearchWidget(),

                // line separator
                Padding(
                  padding: EdgeInsets.only(top: 2.5.h, bottom: 2.5.h),
                  child: Container(
                    height: 0.1.h,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),

                // list of countries
                FutureBuilder(
                  future: Provider.of<Auth>(context).getActiveCountries(),
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.none ||
                        snapshot.hasData == null) {
                      //print('project snapshot data is: ${projectSnap.data}');
                      return Container();
                    }
                    var snapData = snapshot.data;
                    return CountriesList(snapData: snapData);
                  },
                  // child:
                ),
              ],
            ),
          ),
        ));
  }
}

class CountriesList extends StatelessWidget {
  const CountriesList({
    Key key,
    @required this.snapData,
  }) : super(key: key);

  final List snapData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0.h,
      child: ListView.builder(
        itemCount: snapData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            leading: FlagContainer(
              networkSvg: getLinkSvg(
                snapData[index]['flag'],
              ),
            ),
            title: Text(
              '(+${snapData[index]['callingCode']}) ${snapData[index]['name']}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CreateUserScreen(
                    callingCode: snapData[index]['callingCode'],
                    flag: snapData[index]['flag'],
                    country: snapData[index]['name'],
                    currency: snapData[index]['currencyDetails']['name'],
                  ),
                ),
              );
            },
            // subtitle: Text('jgjgjgj'),
          );
        },
      ),
    );
  }
}
