import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/api/support_api.dart';
import 'data/api/pdf_api.dart';
import 'data/api/user_api.dart';
import 'data/api/activity_api.dart';
import 'data/repositories/support_repository_impl.dart';
import 'data/repositories/pdf_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';
import 'data/repositories/activity_repository_impl.dart';
import 'application/login_use_case.dart';
import 'application/save_pdf_use_case.dart';
import 'application/register_use_case.dart';
import 'application/password_use_case.dart';
import 'application/support_use_case.dart';
import 'application/get_activities_for_user_use_case.dart';
import 'application/create_quiz_use_case.dart';
import 'application/create_linkers_use_case.dart';
import 'application/create_gaps_use_case.dart';
import 'application/create_flashcard_use_case.dart';
import 'application/get_pdfs_use_case.dart';
import 'application/rating_activity_use_case.dart';
import 'application/edit_profile_use_case.dart';
import 'application/add_user_points_use_case.dart';
import 'ui/pages/entrypoint.dart';
import 'ui/pages/login_screen.dart';
import 'ui/pages/register_screen.dart';
import 'ui/pages/terms_conditions_screen.dart';
import 'ui/pages/views/profile/configuration_screen.dart';
import 'ui/pages/views/games/games_screen.dart';
import 'ui/pages/views/profile/support_screen.dart';
import 'ui/pages/views/profile/password_screen.dart';
import 'ui/pages/views/profile/information_screen.dart';
import 'ui/pages/views/create/select_pdf_screen.dart';
import 'ui/providers/login_provider.dart';
import 'ui/providers/upload_pdf_provider.dart';
import 'ui/providers/register_provider.dart';
import 'ui/providers/support_provider.dart';
import 'ui/providers/quiz_provider.dart';
import 'ui/providers/gaps_provider.dart';
import 'ui/providers/linkers_provider.dart';
import 'ui/providers/flashcard_provider.dart';
import 'ui/providers/rate_activity_provider.dart';
import 'ui/providers/edit_profile_provider.dart';
import 'ui/providers/password_provider.dart';
import 'ui/providers/add_user_points_provider.dart';
import 'ui/providers/get_activities_for_user_provider.dart';
import 'ui/providers/get_pdfs_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/activity_tracking_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Crear una instancia de UserApi
  final userApi = UserApi();
  final supportApi = SupportApi();
  final pdfApi = PdfApi();
  final activityApi = ActivityApi();
  final activityTrackingService = ActivityTrackingService();

  runApp(
    MultiProvider(
      providers: [
        Provider<ActivityTrackingService>.value(
          value: activityTrackingService,
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(LoginUseCase(UserRepositoryImpl(userApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => RegisterProvider(RegisterUseCase(UserRepositoryImpl(userApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => PasswordProvider(PasswordUseCase(UserRepositoryImpl(userApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => EditProfileProvider(EditProfileUseCase(UserRepositoryImpl(userApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => SupportProvider(SupportUseCase(SupportRepositoryImpl(supportApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadPdfProvider(SavePdfUseCase(PdfRepositoryImpl(pdfApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadPdfProvider(SavePdfUseCase(PdfRepositoryImpl(pdfApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => GetPdfsProvider(GetPdfsUseCase(PdfRepositoryImpl(pdfApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(CreateQuizUseCase(ActivityRepositoryImpl(activityApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => GapsProvider(CreateGapsUseCase(ActivityRepositoryImpl(activityApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => RateActivityProvider(RatingActivityUseCase(ActivityRepositoryImpl(activityApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => FlashcardProvider(CreateFlashcardUseCase(ActivityRepositoryImpl(activityApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => LinkersProvider(CreateLinkersUseCase(ActivityRepositoryImpl(activityApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => AddUserPointsProvider(AddUserPointsUseCase(UserRepositoryImpl(userApi))),
        ),
        ChangeNotifierProvider(
          create: (_) => GetActivitiesForUserProvider(GetActivitiesForUserUseCase(ActivityRepositoryImpl(activityApi))),
        ),
      ],
      child: MyApp(activityTrackingService: activityTrackingService),
    ),
  );
}

class MyApp extends StatefulWidget {
  final ActivityTrackingService activityTrackingService;

  MyApp({Key? key, required this.activityTrackingService}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            widget.activityTrackingService.registerClick();
          },
          child: MaterialApp(
            title: 'Flutter App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(
                fontSizeFactor: 1.sp,
              ),
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('es', ''), // Español
            ],
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/terms_conditions': (context) => TermsConditionsScreen(),
              '/entrypoint': (context) => MainScreen(),
              '/configuration': (context) => ConfigurationScreen(),
              '/support': (context) => SupportScreen(),
              '/password': (context) => PasswordScreen(),
              '/information': (context) => ProfileInformationScreen(),
              '/select_pdf': (context) => SelectPdfScreen(),
              '/games': (context) => GamesScreen(),
            },
          ),
        );
      },
    );
  }
}
