class MobileMenu {
   int? mobileMenuKid;
   String? mobileMenuMenuName;
   String? mobileMenuType;
   String? mobileMenuPath;
   String? mobileMenuMenuIcon;
   String? mobileMenuParentName;

  MobileMenu({
     this.mobileMenuKid,
     this.mobileMenuMenuName,
     this.mobileMenuType,
      this.mobileMenuPath,
     this.mobileMenuMenuIcon,
     this.mobileMenuParentName,
  });

  // Factory method to create an instance from JSON
  factory MobileMenu.fromJson(Map<String, dynamic> json) {
    return MobileMenu(
      mobileMenuKid: json['MobileMenu_kid'] as int,
      mobileMenuMenuName: json['MobileMenu_MenuName'] as String,
      mobileMenuType: json['MobileMenu_type'] as String,
      mobileMenuPath: json['MobileMenu_Path'] as String?,
      mobileMenuMenuIcon: json['MobileMenu_MenuIcon'] as String,
      mobileMenuParentName: json['MobileMenu_ParentName'] as String,
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'MobileMenu_kid': mobileMenuKid,
      'MobileMenu_MenuName': mobileMenuMenuName,
      'MobileMenu_type': mobileMenuType,
      'MobileMenu_Path': mobileMenuPath,
      'MobileMenu_MenuIcon': mobileMenuMenuIcon,
      'MobileMenu_ParentName': mobileMenuParentName,
    };
  }
}


class MenuList{

static List<PrMobileMenu>  listMenu = [];

}
class SubMenuList{

static List<MobileMenu>  SublistMenu = [];
static String  menuTitle = "";

}


class PrMobileMenu {
   String? mobileMenuParentName;
   String? mobileMenuIcon;

  PrMobileMenu({
     this.mobileMenuParentName,
     this.mobileMenuIcon,
  });

  // Factory method to create an instance from JSON
  factory PrMobileMenu.fromJson(Map<String, dynamic> json) {
    return PrMobileMenu(
      mobileMenuParentName: json['MobileMenu_ParentName'] as String,
      mobileMenuIcon: json['MobileMenu_MobileMenuIcon'] as String,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'MobileMenu_ParentName': mobileMenuParentName,
      'MobileMenu_MobileMenuIcon': mobileMenuIcon,
    };
  }
}

