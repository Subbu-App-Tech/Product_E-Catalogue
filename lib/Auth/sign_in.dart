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

// class SecureStorage {
//   final storage = FlutterSecureStorage();

//   //Save Credentials
//   Future saveCredentials(GoogleSignInAccount gaccount) async {
//     // print(token.expiry.toIso8601String());
//     await storage.write(key: "email", value: gaccount.email);
//     await storage.write(key: "name", value: gaccount.displayName);
//     await storage.write(key: "imageurl", value: gaccount.photoUrl);
//     // await storage.write(key: "refreshToken", value: refreshToken);
//   }

//   //Get Saved Credentials
//   Future<Map<String, dynamic>> getCredentials() async {
//     var result = await storage.readAll();
//     if (result.length == 0) return null;
//     return result;
//   }

//   //Clear Saved Credentials
//   Future clear() {
//     return storage.deleteAll();
//   }
// }

// Future uploadImageToGoogleDriveAndGetId() async {
//   // print('trial - > $googleSignInAccount');
//   String imageid;
//   // String imagepath;
//   if (googleauthheader != null) {
//     print(googleauthheader);
//     var client = GoogleHttpClient(await googleauthheader);
//     var drive = ga.DriveApi(client);
//     ga.File fileToUpload = ga.File();
//     var file = await ImagePicker.pickImage(source: ImageSource.gallery);
//     fileToUpload.parents = ["appDataFolder"];
//     print('Picked file path : ${file.absolute.path}');
//     fileToUpload.name = path.basename(file.absolute.path);
//     var response = await drive.files.create(
//       fileToUpload,
//       uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
//     );
//     // print('res ==>  ${response.teamDriveId}');
//     print('res ==>  ${response.id}'); //image id
//     // print('res ==>  ${response.driveId}');
//     imageid = response.id;
//     // imagepath = await downloadGoogleDriveFile(imageid);
//   }
//   return imageid;
// }

// Future downloadGoogleDriveFile(String gdID) async {
//   String imagepath;
//   if (googleauthheader != null) {
//     var client = GoogleHttpClient(await googleauthheader);
//     var drive = ga.DriveApi(client);
//     ga.Media file = await drive.files
//         .get(gdID, downloadOptions: ga.DownloadOptions.FullMedia);
//     print(file.stream);
//     final directory = await getExternalStorageDirectory();
//     print(directory.path);
//     final saveFile =
//         File('${directory.path}/${new DateTime.now().millisecondsSinceEpoch}');
//     List<int> dataStore = [];
//     file.stream.listen((data) {
//       print("DataReceived: ${data.length}");
//       dataStore.insertAll(dataStore.length, data);
//     }, onDone: () {
//       print("Task Done");
//       saveFile.writeAsBytes(dataStore);
//       print("File saved at ${saveFile.path}");
//       imagepath = saveFile.path;
//     }, onError: (error) {
//       print("Some Error");
//     });
//   }
//   return imagepath;
// }
