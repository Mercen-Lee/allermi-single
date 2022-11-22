/// Allergy Data Structure
/// Created by Mercen on 2022/11/06.

import Foundation
import RealmSwift

class AllergyData: Object {
    @objc dynamic var productNumber: Int = 0
    @objc dynamic var productName: String = String()
    @objc dynamic var ingredients: String = String()
    var allergyList = List<String>()
    @objc dynamic var productType: String = String()
    @objc dynamic var companyName: String = String()
    @objc dynamic var imageURL: String = String()
    @objc dynamic var metaURL: String = String()
    @objc dynamic var nutrient: String = String()
}

