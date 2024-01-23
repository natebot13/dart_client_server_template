import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

final mfaAction = AuthStateChangeAction<MFARequired>(
  (context, state) async {
    await startMFAVerification(
      resolver: state.resolver,
      context: context,
    );
  },
);

final actionCodeSettings = ActionCodeSettings(
  url: '<some_firebase_auth_project>',
  handleCodeInApp: true,
  androidMinimumVersion: '1',
  androidPackageName: '<some_package_name>',
  iOSBundleId: '<some_package_name>',
);
