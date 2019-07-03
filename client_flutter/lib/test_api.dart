import './src/resources/repository.dart';

class TestApi {

  final repo = Repository.getInstance();

  Future testVerifyUid() async {
    final String response = await repo.verifyUserId('105213007');

    if (response == 'fail') {
      print('fail');
    } else {
      print('Your verified code is : $response');
    }
  }
}
