class User {
    final String mail;
    final String firstName;
    final String lastName;
    final String avatar;
    final int phoneNum;
    final dynamic dateOfBirth;

    User({
        required this.mail,
        required this.firstName,
        required this.lastName,
        required this.avatar,
        required this.phoneNum,
        this.dateOfBirth,
    });

    User copyWith({
        String? mail,
        String? firstName,
        String? lastName,
        String? avatar,
        int? phoneNum,
        dynamic dateOfBirth,
    }) => 
        User(
            mail: mail ?? this.mail,
            firstName: firstName ?? this.firstName,
            lastName: lastName ?? this.lastName,
            avatar: avatar ?? this.avatar,
            phoneNum: phoneNum ?? this.phoneNum,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        );

    factory User.fromJson(Map<String, dynamic> json) => User(
        mail: json["mail"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: json["avatar"],
        phoneNum: json["phoneNum"],
        dateOfBirth: json["dateOfBirth"],
    );

    Map<String, dynamic> toJson() => {
        "mail": mail,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar,
        "phoneNum": phoneNum,
        "dateOfBirth": dateOfBirth,
    };
}