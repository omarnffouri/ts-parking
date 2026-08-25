import 'package:flutter/material.dart';
import 'package:ts_parking/app/routes/app_pages.dart';

enum ProfileMenuItem {
  myVehicles,
  paymentMethods,
  subscriptions,
  invoices,
  overstayCharges,
  termsAndConditions,
  deleteAccount,
  logout,
}

extension ProfileMenuItemX on ProfileMenuItem {
  String get title => switch (this) {
    ProfileMenuItem.myVehicles => 'My Vehicles',
    ProfileMenuItem.paymentMethods => 'Payment Methods',
    ProfileMenuItem.subscriptions => 'Subscriptions',
    ProfileMenuItem.invoices => 'Invoices',
    ProfileMenuItem.overstayCharges => 'Overstay Charges',
    ProfileMenuItem.termsAndConditions => 'Terms & Conditions',
    ProfileMenuItem.deleteAccount => 'Delete Account',
    ProfileMenuItem.logout => 'Logout',
  };

  IconData get icon => switch (this) {
    ProfileMenuItem.myVehicles => Icons.local_shipping_outlined,
    ProfileMenuItem.paymentMethods => Icons.wallet,
    ProfileMenuItem.subscriptions => Icons.autorenew_rounded,
    ProfileMenuItem.invoices => Icons.receipt_long_outlined,
    ProfileMenuItem.overstayCharges => Icons.money_off_csred_outlined,
    ProfileMenuItem.termsAndConditions => Icons.description_outlined,
    ProfileMenuItem.deleteAccount => Icons.delete,
    ProfileMenuItem.logout => Icons.logout_rounded,
  };

  String? get route => switch (this) {
    ProfileMenuItem.myVehicles => Routes.MY_VEHICLES,
    ProfileMenuItem.paymentMethods => Routes.PAYMENT_METHOD,
    ProfileMenuItem.subscriptions => Routes.SUBSCRIPTIONS,
    ProfileMenuItem.invoices => Routes.INVOICES,
    ProfileMenuItem.overstayCharges => Routes.OVERSTAY_CHARGES,
    _ => null,
  };

  bool get isDestructive =>
      this == ProfileMenuItem.deleteAccount || this == ProfileMenuItem.logout;
}
