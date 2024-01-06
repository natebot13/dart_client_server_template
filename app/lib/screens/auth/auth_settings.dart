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
  url: 'https://fwish-e4ba9.firebaseapp.com',
  handleCodeInApp: true,
  androidMinimumVersion: '1',
  androidPackageName: 'me.nathanp.wishr',
  iOSBundleId: 'me.nathanp.wishr',
);
