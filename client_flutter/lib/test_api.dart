import './src/resources/repository.dart';

final apiTest = TestApi();

class TestApi {
  TestApi._();
  final repo = Repository();

  static final _test = TestApi._();

  factory TestApi() {
    return _test;
  }

  Future runTest() {
    return Future.wait(
      [
        testVerifyUid(),
      ],
    );
  }

  Future testVerifyUid() async {
    final String response = await repo.verifyUserId('105213007');

    if (response == 'fail') {
      print('fail');
    } else {
      print('Your verified code is : $response');
    }
  }
}
