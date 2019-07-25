class UserModel {
  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        password = json['password'],
        name = json['name'],
        photo = json['photo'] ?? '',
        gender = json['gender'] ?? -1,
        department = json['department'] ?? '',
        birthday = json['birthday'] ?? '',
        star = json['star'] ?? '',
        scor = json['scor'] ?? 0,
        driverRank = json['driverRank'] ?? 0,
        passengerRank = json['passengerRank'] ?? 0,
        carNumber = json['carNumber'] ?? '',
        driverTimes = json['driverTimes'] ?? 0,
        passengerTimes = json['passengerTimes'] ?? 0,
        assert(userId != null),
        assert(password != null),
        assert(name != null);

  int userId;
  String password;
  String name;
  String photo;
  int gender;
  String department;
  String birthday;
  String star;
  int scor;
  int driverRank;
  int passengerRank;
  String carNumber;
  int driverTimes;
  int passengerTimes;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['password'] = this.password;
    data['name'] = this.name;
    data['photo'] = this.photo;
    data['gender'] = this.gender;
    data['department'] = this.department;
    data['birthday'] = this.birthday;
    data['star'] = this.star;
    data['scor'] = this.scor;
    data['driverRank'] = this.driverRank;
    data['passengerRank'] = this.passengerRank;
    data['carNumber'] = this.carNumber;
    data['driverTimes'] = this.driverTimes;
    data['passengerTimes'] = this.passengerTimes;
    return data;
  }
}
