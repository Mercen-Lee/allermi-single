/// Allergy Data Structure
/// Created by Mercen on 2022/11/06.

enum ProductType {
    case food
    case meat
}

enum AllergyType: String {
    case egg = "난류"
    case meat = "육류"
    case chicken = "닭고기"
    case fish = "생선류"
    case shell = "갑각류"
    case mollusk = "연체동물류"
    case milk = "유제품"
    case treenuts = "견과류"
    case soybean = "대두"
    case flower = "과일류"
    case tomato = "토마토"
    case wheat = "밀"
    case buckwheat = "메밀"
    case sulfurous = "아황산류"
}

struct AllergyData {
    let productNumber: Int
    let productName: String
    let ingredients: String
    let allergyList: [AllergyType]
    let productType: String
    let companyName: String
    let imageURL: String
    let MetaURL: String
    let Nutrient: String
}
