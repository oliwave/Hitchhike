import './src/resources/cached/secure_strorage.dart';

import './src/resources/restful/request_method.dart';

import './src/resources/repository.dart';

final apiTest = TestApi();

class TestApi {
  TestApi._();
  final _api = Repository.getApi;

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
    final response = await _api.sendHttpRequest(
      VerifyUserIdRequest(
        userId: '105213007',
      ),
    );

    if (response == 'fail') {
      print('fail');
    } else {
      print('Your verified code is : $response');
    }
  }
}
