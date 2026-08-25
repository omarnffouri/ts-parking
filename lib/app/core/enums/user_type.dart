enum UserType { client, driver, ownerOperator, unknown }

extension UserTypeX on UserType {
  static UserType fromApiName(String? apiName) {
    return switch (apiName) {
      'cat_client' => UserType.client,
      'cat_driver' => UserType.driver,
      'cat_owner_operator' => UserType.ownerOperator,
      _ => UserType.unknown,
    };
  }

  String get apiName {
    return switch (this) {
      UserType.client => 'cat_client',
      UserType.driver => 'cat_driver',
      UserType.ownerOperator => 'cat_owner_operator',
      UserType.unknown => 'unknown',
    };
  }

  String get label {
    return switch (this) {
      UserType.client => 'Client',
      UserType.driver => 'Driver',
      UserType.ownerOperator => 'Owner Operator',
      UserType.unknown => 'Unknown',
    };
  }
}
