class CouponManager {
  static final Map<String, double> _coupons = {};

  static void addCoupon(String couponCode, double discountPercentage) {
    _coupons[couponCode.toUpperCase()] = discountPercentage;
  }

  static double getCouponDiscount(String couponCode) {
    return _coupons[couponCode.toUpperCase()] ?? 0.0;
  }

  static bool couponExists(String couponCode) {
    return _coupons.containsKey(couponCode.toUpperCase());
  }

  static Map<String, double> getAllCoupons() {
    return Map.from(_coupons);
  }

  static void removeCoupon(String couponCode) {
    _coupons.remove(couponCode.toUpperCase());
  }
}
