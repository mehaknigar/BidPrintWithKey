import 'dart:async';
import 'package:bidprint/account/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';

enum PhoneAuthState {
  Started,
  CodeSent,
  CodeResent,
  Verified,
  Failed,
  Error,
  AutoRetrievalTimeOut
}

class FirebasePhoneAuth {
  static var _authCredential, actualCode, phone, status;
  static StreamController<String> statusStream = StreamController.broadcast();
  static StreamController<PhoneAuthState> phoneAuthState =
      StreamController.broadcast();
  static Stream stateStream = phoneAuthState.stream;

  static instantiate({String phoneNumber}) async {
    assert(phoneNumber != null);
    phone = phoneNumber;
    print(phone);
    startAuth();
  }

  static dispose() {
//    statusStream.close();
//    phoneAuthState.close();
  }

  static startAuth() {
    statusStream.stream
        .listen((String status) => print("PhoneAuth: " + status));
    addStatus('Phone auth started');
    FireBase.auth
        .verifyPhoneNumber(
            phoneNumber: phone.toString(),
            timeout: Duration(seconds: 120),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((value) {
      addStatus('Code sent');
    }).catchError((error) {
      addStatus(error.toString());
    });
  }

  static final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
    actualCode = verificationId;
    addStatus("\nEnter the code sent to " + phone);
    addState(PhoneAuthState.CodeSent);
  };

  static final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
    actualCode = verificationId;
    addStatus("\nAuto retrieval time out");
    addState(PhoneAuthState.AutoRetrievalTimeOut);
  };

  static final PhoneVerificationFailed verificationFailed =
      (AuthException authException) {
    addStatus('${authException.message}');
    addState(PhoneAuthState.Error);
    if (authException.message.contains('not authorized'))
      addStatus('App not authroized');
    else if (authException.message.contains('Network'))
      addStatus('Please check your internet connection and try again');
    else
      addStatus('Something has gone wrong, please try later ' +
          authException.message);
  };

  static final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential auth) {
    addStatus('Auto retrieving verification code');

    FireBase.auth.signInWithCredential(auth).then((AuthResult value) {
      if (value.user != null) {
        addStatus(status = 'Authentication successful');
        addState(PhoneAuthState.Verified);
        // onAuthenticationSuccessful();
        return true;
      } else {
        addState(PhoneAuthState.Failed);
        addStatus('Invalid code/invalid authentication');
        return false;
      }
    }).catchError((error) {
      addState(PhoneAuthState.Error);
      addStatus('Something has gone wrong, please try later $error');
      return false;
    });
  };

  static bool signInWithPhoneNumber({String smsCode}) {
    _authCredential = PhoneAuthProvider.getCredential(verificationId: actualCode, smsCode: smsCode);

    FireBase.auth .signInWithCredential(_authCredential).then((AuthResult result) async {
      addStatus('---Authentication successful---');
      addState(PhoneAuthState.Verified);
      return true;
    }).catchError((error) {
      addState(PhoneAuthState.Error);
      addStatus('--Something has gone wrong, please try later(signInWithPhoneNumber) $error--');
      return false;
    });
    return true;
  }

  // static onAuthenticationSuccessful() {
  //   //  TODO: handle authentication successful
  //   // navigatorKey.currentState.pushNamed("/home");
  //   print("suceessfully done code verification");
  // }

  static addState(PhoneAuthState state) {
    print(state);
    phoneAuthState.sink.add(state);
  }

  static void addStatus(String s) {
    statusStream.sink.add(s);
    print(s);
  }
}
