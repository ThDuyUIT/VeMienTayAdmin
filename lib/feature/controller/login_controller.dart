import 'package:booking_transition_admin/feature/presentation/Authentication/login.dart';
import 'package:booking_transition_admin/feature/presentation/scaffold_navigationrail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController {
  Future onLogin(String username, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: pass);

      //String userId = 'KH${userCredential.user!.uid}';
      String userId = userCredential.user!.uid;
      if (userId == 'Fv4mfoOUoTQnx9YCkYRhad63WhB2') {
        Get.offAll(ScaffoldWithNavigationRail(selectedIndex: 0));
        //LoginPage.isLogin = true;
      }
    } catch (e) {
      print(e);
    }
  }
}
