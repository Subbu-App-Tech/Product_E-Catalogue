import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/drive/v3.dart' as ga;
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'package:image_picker/image_picker.dart';
// import 'package:http/io_client.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
  // 'https://www.googleapis.com/auth/drive.appdata',
  // 'https://www.googleapis.com/auth/drive.file',
]);
GoogleSignInAccount? googleSignInAccount;

Future get googleauthheader async {
  GoogleSignInAccount? gauth = await googleSignIn.signInSilently();
  if (gauth == null) {
    signInWithGoogle();
    GoogleSignInAccount gauth =
        await (googleSignIn.signInSilently() as Future<GoogleSignInAccount>);
    return gauth.authHeaders;
  }
  return gauth.authHeaders;
}

// class GoogleHttpClient extends IOClient {
//   Map<String, String> _headers;
//   GoogleHttpClient(this._headers) : super();
//   @override
//   Future<IOStreamedResponse> send(http.BaseRequest request) {
//     return super.send(request..headers.addAll(_headers));
//   }
//   @override
//   Future<http.Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));
// }

Future<String> signInWithGoogle() async {
  GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  GoogleSignInAuthentication googleSignInAuthentication =
      (await googleSignInAccount?.authentication)!;
  // if (googleSignInAuthentication != null) {
  print(googleSignInAuthentication);
  AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken);
  final UserCredential authResult = await auth.signInWithCredential(credential);
  final User? user = authResult.user;
  if (user != null) {
    assert(!user.isAnonymous);
    User currentUser = auth.currentUser!;
    assert(user.uid == currentUser.uid);
  }
  return 'signInWithGoogle succeeded: $user';
  // }
  // return 'Not Found';
}

void signOutGoogle() async {
  await googleSignIn.signOut();
  await auth.signOut();
  // print("User Sign Out");
}
