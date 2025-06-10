import 'package:go_router/go_router.dart';

class Routes{
////////////////////////////////////////////////////////////////////////////// auth Pages
  static const String splashRoute = '/';
  static const String loginScreen = '/login';
  // static const String loginScreen = '/download-center';
  static const String adminSignUpScreen = '/signup';
  static const String appleauth = '/appleauth';
  ///////////////////////////////////////////////////////////////
  static const String verifyCodeSocial = '/signup/verifyphone/verifycode';
  static const String verifyCodeChooseSocial = '/signup/verifyphone/verifycodeverifycode';
  ///////////////////////////////////////////////////////////////
  static const String verifyPhoneNumber = '/signup/verifyphone';
  static const String changePhoneNumber = '/signup/verifyphone/changephone';
  static const String verifyCodeChangeNumber = '/signup/verifyphone/changephone/verifycode';

  ///////////////////////////////////////////////////////////////
  static const String createNewPasswordScreen = '/createnewpassword';
  static const String passwordChangedSuccessful = '/passwordchangedsuccessful';
  static const String resetPassword = '/resetpassword';
  static const String resetPasswordVerifyCode = '/resetpasswordverifycode';
  static const String verifyCodeResetPassword = '/resetpasswordverifycode/verifycode';
  static const String verifyCodeScreen = '/signup/verifycodesms';
  static const String verifyCodeChooseSignUp = '/signup/verifycode';
  static const String verifyCodeChooseProfile = '/profile/verifycode';
/////////////////////////////////////////////////////////////////////////////////// home pages
  static const String homePage = '/home';
////////////////////////////////////////////////////////////////////////////////////////// Account Pages
  static const String accountSettingFromHome = '/home/accountsetting';
  static const String accountSettingFromDrawer = '/accountsetting';
  static const String wishList = '/wishlist';
/////////////////////////////////////////////////////////////////////////////////// App and addons Pages
  static const String addonsPageFromHome = '/home/application/addons';
  static const String addonsPageFromDrawer = '/application/addons';
  static const String addonsPageFromWishList = '/wishlist/addons';
  static const String addonsPageFromAppPage = '/home/application/apps/addons';
  ///////////////////////////////////////////////////////////////////////////////////
  static const String appPageFromHome = '/home/application/apps';
  static const String appPageFromApplication = '/application/apps';
  static const String appPageFromWishList = '/wishlist/apps';
  static const String appPageFromAddon = '/home/application/addons/apps';
  static const String downloadCenter = '/download-center';
  static const String addonDownloadCenter = '/download-center/addon';
  static const String addonFromAppFromDownloadCenter = '/download-center/app/addon';
  static const String appDownloadCenter = '/download-center/apps';
  //////////////////////////////////////////////////////////////////////////////////////////////
  static const String downloadPage = '/downloads';
  ////////////////////////////////////////////////////////////////////////////////////////////////////
  static const String paymentDetailsFromHome = '/home/invoices/paymentdetails';
  static const String paymentDetailsFromDrawer = '/invoices/paymentdetails';
  static const String paymentDetailsFromHomeVersionCompare = '/home/application/apps/versioncompare/paymentdetails';
  static const String paymentDetailsHomeFromAppPlan = '/home/application/apps/appplan/paymentdetails';
  static const String paymentDetailsHomeFromWishPlan = '/wishlist/apps/appplan/paymentdetails';
  static const String paymentDetailsHomeFromWishPlanVersion = '/wishlist/apps/appplan/versioncompare/paymentdetails';
  static const String paymentDetailsHomeFromWishVersion = '/wishlist/apps/versioncompare/paymentdetails';
  static const String paymentDetailsHomeFromAddon = '/home/application/addons/paymentdetails';
  static const String paymentDetailsFromWishAddon = '/wishlist/addons/paymentdetails';
  static const String paymentDetailsFromSubscription = '$versionCompareFromSubscription/paymentdetails';
  ///////////////////////////////////////////////////////////////////////////////////////////////
  static const String versionCompareFromHome = '/home/application/apps/versioncompare';
  static const String versionCompareFromDrawer = '/application/apps/versioncompare';
  static const String versionCompareFromAppWishList = '/wishist/apps/versioncompare';

  ///////////////////////////////////////////////////////////////////////////////////////////
  static const String addonVersion = '/home/subscriptions/subscriptionversions/addonversion';
/////////////////////////////////////////////////////////////////////////////////////////////// application Pages
  static const String appPlanFromHome = '/home/application/apps/appplan';
  static const String appPlanFromDrawer = '/application/apps/appplan';
  static const String appPlanFromAppsWishList = '/wishist/apps/appplan';
  static const String versionCompareFromAppPlanHome = '/home/application/apps/appplan/versioncompare';
  static const String versionCompareFromAppPlanDrawer = '/application/apps/appplan/versioncompare';
  static const String versionCompareFromAppPlanWishList = '/wishist/apps/appplan/versioncompare';
  static const String versionCompareFromSubscription = '$typesSubscriptionFromHome/versioncompare';

  static const String applicationsPage = '/applications';
  static const String applicationsPageFromHome = '/home/application';

////////////////////////////////////////////////////////////////////////////////////// billing Pages
  static const String invoicesScreen = '/invoices';
  static const String invoicesScreenFromHome = '/home/invoices';
  //////////////////////////////////////////////////////////////////////////////////////////////////
  static const String manageSubscription = '/subscriptions';
  static const String manageSubscriptionFromHome = '/home/subscriptions';
  /////////////////////////////////////////////////////////////////////////////////////////////////////
  static const String typesSubscriptionFromHome = '/home/subscriptions/subscriptionversions';
  static const String typesSubscriptionFromSubscription = '/subscriptions/subscriptionversions';
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  static const String paymentAccountListFromHome = '/home/paymentaccount';
  static const String paymentAccountListFromDrawer = '/paymentaccount';
  static const String paymentAccountNumberFromPaymentAccountHome = '/home/paymentaccount/paymentaccountnumber';
  static const String paymentAccountNumberFromPaymentAccountDrawer = '/paymentaccount/paymentaccountnumber';
  static const String managePaymentMethodsFromPaymentAccountNumberHome = '/home/paymentaccount/paymentaccountnumber/paymentmethods';
  static const String managePaymentMethodsFromPaymentAccountNumberDrawer = '/paymentaccount/paymentaccountnumber/paymentmethods';
//////////////////////////////////////////////////////////////////////////////////////////////////// devices Pages
  static const String devicesFromPlatFormDevices = '/platformdevices/devices';
  static const String devicesFromHome = '/home/platformdevices/devices';
  /////////////////////////////////////////////////////////////////
  static const String platformDevices = '/platformdevices';
  static const String platformDevicesFromHome = '/home/platformdevices';
////////////////////////////////////////////////////////////////////////////// profile Pages
  static const String profileInfoFromHome = '/home/profile';
  static const String profileInfoFromDrawer = '/profile';
////////////////////////////////////////////////////////////////////////////// tickets Pages
  static const String mainTicketsFromHome = '/home/tickets';
  static const String mainTicketsFromDrawer = '/tickets';
  static const String newTicketFromTicket = '/home/tickets/newticket';
  static const String newTicketFromHome = '/home/newticket';
  static const String chatTicketMobile = '/home/chatTicket';
//////////////////////////////////////////////////////////////////////////////////////////////////////////////// workspace Pages
  static const String preparingDataScreenFromNormal = '/signup/verifycodesms/preparingdata';
  static const String preparingDataScreenFromSocial = '/signup/verifyphone/verifycode/preparingdata';
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
  static const String workSpaceFromHome = '/home/workspace';
  static const String workSpaceFromDrawer = '/workspace';
  static const String workSpaceDetailsFromWorkspaceHome = '/home/workspace/workspacedetails';
  static const String workSpaceDetailsFromDrawer = '/workspace/workspacedetails';
  static const String workSpaceBackupFromWorkSpaceDetails = '/home/workspace/workspacedetails/workspacebackup';
  static const String workSpaceBackupFromDrawer = '/workspace/workspacedetails/workspacebackup';
////////////////////////////////////////////////////////////////////////////// payment
  static const String paymentSuccess = '/paymentsuccess';
  static const String paymentFailed = '/paymentfailed';
  static const String paymentSuccessPayMob = '/paymentsuccesspaymob';
////////////////////////////////////////////////////////////////////////////// Module
  static const String module = '/module';
  static const String moduleAppPageFromHome = '/home/application/apps/module';
  static const String moduleAppPageFromApplication = '/application/apps/module';
  static const String moduleAppPageFromWishList = '/wishlist/apps/module';
  static const String moduleAppPageFromAddon = '/home/application/addons/apps/module';
}


//