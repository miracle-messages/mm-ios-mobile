//
//  Country.swift
//  MiracleMessages
//
//  Created by Eric Cormack on 6/25/17.
//  Copyright © 2017 Win Inc. All rights reserved.
//

import UIKit

enum Country: String {
    case Afghanistan
    case ÅlandIslands = "Åland Islands"
    case Albania
    case Algeria
    case Andorra
    case Angola
    case Anguilla
    case AntiguaandBarbuda = "Antigua and Barbuda"
    case Argentina
    case Armenia
    case Aruba
    case Australia
    case Austria
    case Azerbaijan
    case Bahamas
    case Bahrain
    case Bangladesh
    case Barbados
    case Belarus
    case Belgium
    case Belize
    case Benin
    case Bermuda
    case Bhutan
    case Bolivia
    case BosniaandHerzegovina = "Bosnia and Herzegovina"
    case Botswana
    case Brazil
    case BritishIndianOceanTerritory = "British Indian Ocean Territory"
    case Brunei
    case Bulgaria
    case BurkinaFaso = "Burkina Faso"
    case Burundi
    case Cambodia
    case Cameroon
    case Canada
    case CapeVerde = "Cape Verde"
    case CaymanIslands = "Cayman Islands"
    case CentralAfricanRepublic = "Central African Republic"
    case Chad
    case Chile
    case China
    case ChristmasIsland = "Christmas Island"
    case CocosIslands = "Cocos (Keeling) Islands"
    case Colombia
    case Comoros
    case Congo
    case CookIslands = "Cook Islands"
    case CostaRica = "Costa Rica"
    case CoteDIvoire = "Cote D'Ivoire"
    case Croatia
    case Cuba
    case Cyprus
    case CzechRepublic = "Czech Republic"
    case DemocraticRepublicoftheCongo = "Democratic Republic of the Congo"
    case Denmark
    case Djibouti
    case Dominica
    case DominicanRepublic = "Dominican Republic"
    case EastTimor = "East Timor"
    case Ecuador
    case Egypt
    case ElSalvador = "El Salvador"
    case EquatorialGuinea = "Equatorial Guinea"
    case Eritrea
    case Estonia
    case Ethiopia
    case FalklandIslands = "Falkland Islands"
    case FaroeIslands = "Faroe Islands"
    case Fiji
    case Finland
    case France
    case FrenchGuiana = "French Guiana"
    case FrenchPolynesia = "French Polynesia"
    case FrenchSouthernTerritories = "French Southern Territories"
    case Gabon
    case Gambia
    case Georgia
    case Germany
    case Ghana
    case Gibraltar
    case Greece
    case Greenland
    case Grenada
    case Guadeloupe
    case Guatemala
    case Guernsey
    case Guinea
    case GuineaBissau = "Guinea-Bissau"
    case Guyana
    case Haiti
    case Honduras
    case HongKong = "Hong Kong"
    case Hungary
    case Iceland
    case India
    case Indonesia
    case Iran
    case Iraq
    case Ireland
    case IsleofMan = "Isle of Man"
    case Israel
    case Italy
    case Jamaica
    case Japan
    case Jersey
    case Jordan
    case Kazakhstan
    case Kenya
    case Kiribati
    case Kuwait
    case Kyrgyzstan
    case Laos
    case Latvia
    case Lebanon
    case Lesotho
    case Liberia
    case Libya
    case Liechtenstein
    case Lithuania
    case Luxembourg
    case Macao
    case Macedonia
    case Madagascar
    case Malawi
    case Malaysia
    case Maldives
    case Mali
    case Malta
    case Martinique
    case Mauritania
    case Mauritius
    case Mayotte
    case Mexico
    case Moldova
    case Monaco
    case Mongolia
    case Montserrat
    case Morocco
    case Mozambique
    case Myanmar
    case Namibia
    case Nauru
    case Nepal
    case Netherlands
    case NetherlandsAntilles = "Netherlands Antilles"
    case NewCaledonia = "New Caledonia"
    case NewZealand = "New Zealand"
    case Nicaragua
    case Niger
    case Nigeria
    case Niue
    case NorfolkIsland = "Norfolk Island"
    case NorthKorea = "North Korea"
    case Norway
    case Oman
    case Pakistan
    case Palestine
    case Panama
    case PapuaNewGuinea = "Papua New Guinea"
    case Paraguay
    case Peru
    case Philippines
    case Pitcairn
    case Poland
    case Portugal
    case Qatar
    case Reunion
    case Romania
    case Russia
    case Rwanda
    case SaintHelena = "Saint Helena"
    case SaintKittsandNevis = "Saint Kitts and Nevis"
    case SaintLucia = "Saint Lucia"
    case SaintPierreandMiquelon = "Saint Pierre and Miquelon"
    case SaintVincentandtheGrenadines = "Saint Vincent and the Grenadines"
    case Samoa
    case SanMarino = "San Marino"
    case SaoTomeandPrincipe = "Sao Tome and Principe"
    case SaudiArabia = "Saudi Arabia"
    case Senegal
    case SerbiaandMontenegro = "Serbia and Montenegro"
    case Seychelles
    case SierraLeone = "Sierra Leone"
    case Singapore
    case Slovakia
    case Slovenia
    case SolomonIslands = "Solomon Islands"
    case Somalia
    case SouthAfrica = "South Africa"
    case SouthKorea = "South Korea"
    case Spain
    case SriLanka = "Sri Lanka"
    case Sudan
    case Suriname
    case Svalbard
    case Swaziland
    case Sweden
    case Switzerland
    case Syria
    case Taiwan
    case Tajikistan
    case Tanzania
    case Thailand
    case Togo
    case Tokelau
    case Tonga
    case TrinidadandTobago = "Trinidad and Tobago"
    case Tunisia
    case Turkey
    case Turkmenistan
    case TurksandCaicosIslands = "Turks and Caicos Islands"
    case Tuvalu
    case Uganda
    case Ukraine
    case UnitedArabEmirates = "United Arab Emirates"
    case UnitedKingdom = "United Kingdom"
    case UnitedStates = "United States"
    case Uruguay
    case Uzbekistan
    case Vanuatu
    case VaticanCity = "Vatican City"
    case Venezuela
    case Vietnam
    case VirginIslandsBritish = "British Virgin Islands"
    case WallisandFutuna = "Wallis and Futuna"
    case WesternSahara = "Western Sahara"
    case Yemen
    case Zambia
    case Zimbabwe
    
    var name: String { return rawValue }
    
    var code: String {
        switch self {
        case .Afghanistan: return "AF"
        case .ÅlandIslands: return "AX"
        case .Albania: return "AL"
        case .Algeria: return "DZ"
        case .Andorra: return "AD"
        case .Angola: return "AO"
        case .Anguilla: return "AI"
        case .AntiguaandBarbuda: return "AG"
        case .Argentina: return "AR"
        case .Armenia: return "AM"
        case .Aruba: return "AW"
        case .Australia: return "AU"
        case .Austria: return "AT"
        case .Azerbaijan: return "AZ"
        case .Bahamas: return "BS"
        case .Bahrain: return "BH"
        case .Bangladesh: return "BD"
        case .Barbados: return "BB"
        case .Belarus: return "BY"
        case .Belgium: return "BE"
        case .Belize: return "BZ"
        case .Benin: return "BJ"
        case .Bermuda: return "BM"
        case .Bhutan: return "BT"
        case .Bolivia: return "BO"
        case .BosniaandHerzegovina: return "BA"
        case .Botswana: return "BW"
        case .Brazil: return "BR"
        case .BritishIndianOceanTerritory: return "IO"
        case .Brunei: return "BN"
        case .Bulgaria: return "BG"
        case .BurkinaFaso: return "BF"
        case .Burundi: return "BI"
        case .Cambodia: return "KH"
        case .Cameroon: return "CM"
        case .Canada: return "CA"
        case .CapeVerde: return "CV"
        case .CaymanIslands: return "KY"
        case .CentralAfricanRepublic: return "CF"
        case .Chad: return "TD"
        case .Chile: return "CL"
        case .China: return "CN"
        case .ChristmasIsland: return "CX"
        case .CocosIslands: return "CC"
        case .Colombia: return "CO"
        case .Comoros: return "KM"
        case .Congo: return "CG"
        case .CookIslands: return "CK"
        case .CostaRica: return "CR"
        case .CoteDIvoire: return "CI"
        case .Croatia: return "HR"
        case .Cuba: return "CU"
        case .Cyprus: return "CY"
        case .CzechRepublic: return "CZ"
        case .DemocraticRepublicoftheCongo: return "CD"
        case .Denmark: return "DK"
        case .Djibouti: return "DJ"
        case .Dominica: return "DM"
        case .DominicanRepublic: return "DO"
        case .EastTimor: return "TL"
        case .Ecuador: return "EC"
        case .Egypt: return "EG"
        case .ElSalvador: return "SV"
        case .EquatorialGuinea: return "GQ"
        case .Eritrea: return "ER"
        case .Estonia: return "EE"
        case .Ethiopia: return "ET"
        case .FalklandIslands: return "FK"
        case .FaroeIslands: return "FO"
        case .Fiji: return "FJ"
        case .Finland: return "FI"
        case .France: return "FR"
        case .FrenchGuiana: return "GF"
        case .FrenchPolynesia: return "PF"
        case .FrenchSouthernTerritories: return "TF"
        case .Gabon: return "GA"
        case .Gambia: return "GM"
        case .Georgia: return "GE"
        case .Germany: return "DE"
        case .Ghana: return "GH"
        case .Gibraltar: return "GI"
        case .Greece: return "GR"
        case .Greenland: return "GL"
        case .Grenada: return "GD"
        case .Guadeloupe: return "GP"
        case .Guatemala: return "GT"
        case .Guernsey: return "GG"
        case .Guinea: return "GN"
        case .GuineaBissau: return "GW"
        case .Guyana: return "GY"
        case .Haiti: return "HT"
        case .Honduras: return "HN"
        case .HongKong: return "HK"
        case .Hungary: return "HU"
        case .Iceland: return "IS"
        case .India: return "IN"
        case .Indonesia: return "ID"
        case .Iran: return "IR"
        case .Iraq: return "IQ"
        case .Ireland: return "IE"
        case .IsleofMan: return "IM"
        case .Israel: return "IL"
        case .Italy: return "IT"
        case .Jamaica: return "JM"
        case .Japan: return "JP"
        case .Jersey: return "JE"
        case .Jordan: return "JO"
        case .Kazakhstan: return "KZ"
        case .Kenya: return "KE"
        case .Kiribati: return "KI"
        case .Kuwait: return "KW"
        case .Kyrgyzstan: return "KG"
        case .Laos: return "LA"
        case .Latvia: return "LV"
        case .Lebanon: return "LB"
        case .Lesotho: return "LS"
        case .Liberia: return "LR"
        case .Libya: return "LY"
        case .Liechtenstein: return "LI"
        case .Lithuania: return "LT"
        case .Luxembourg: return "LU"
        case .Macao: return "MO"
        case .Macedonia: return "MK"
        case .Madagascar: return "MG"
        case .Malawi: return "MW"
        case .Malaysia: return "MY"
        case .Maldives: return "MV"
        case .Mali: return "ML"
        case .Malta: return "MT"
        case .Martinique: return "MQ"
        case .Mauritania: return "MR"
        case .Mauritius: return "MU"
        case .NorthKorea: return "KP"
        case .Mayotte: return "YT"
        case .Mexico: return "MX"
        case .Moldova: return "MD"
        case .Monaco: return "MC"
        case .Mongolia: return "MN"
        case .Montserrat: return "MS"
        case .Morocco: return "MA"
        case .Mozambique: return "MZ"
        case .Myanmar: return "MM"
        case .Namibia: return "NA"
        case .Nauru: return "NR"
        case .Nepal: return "NP"
        case .Netherlands: return "NL"
        case .NetherlandsAntilles: return "AN"
        case .NewCaledonia: return "NC"
        case .NewZealand: return "NZ"
        case .Nicaragua: return "NI"
        case .Niger: return "NE"
        case .Nigeria: return "NG"
        case .Niue: return "NU"
        case .NorfolkIsland: return "NF"
        case .Norway: return "NO"
        case .Oman: return "OM"
        case .Pakistan: return "PK"
        case .Palestine: return "PS"
        case .Panama: return "PA"
        case .PapuaNewGuinea: return "PG"
        case .Paraguay: return "PY"
        case .Peru: return "PE"
        case .Philippines: return "PH"
        case .Pitcairn: return "PN"
        case .Poland: return "PL"
        case .Portugal: return "PT"
        case .Qatar: return "QA"
        case .Reunion: return "RE"
        case .Romania: return "RO"
        case .Russia: return "RU"
        case .Rwanda: return "RW"
        case .SaintHelena: return "SH"
        case .SaintKittsandNevis: return "KN"
        case .SaintLucia: return "LC"
        case .SaintPierreandMiquelon: return "PM"
        case .SaintVincentandtheGrenadines: return "VC"
        case .Samoa: return "WS"
        case .SanMarino: return "SM"
        case .SaoTomeandPrincipe: return "ST"
        case .SaudiArabia: return "SA"
        case .Senegal: return "SN"
        case .SerbiaandMontenegro: return "CS"
        case .Seychelles: return "SC"
        case .SierraLeone: return "SL"
        case .Singapore: return "SG"
        case .Slovakia: return "SK"
        case .Slovenia: return "SI"
        case .SolomonIslands: return "SB"
        case .Somalia: return "SO"
        case .SouthAfrica: return "ZA"
        case .SouthKorea: return "KR"
        case .Spain: return "ES"
        case .SriLanka: return "LK"
        case .Sudan: return "SD"
        case .Suriname: return "SR"
        case .Svalbard: return "SJ"
        case .Swaziland: return "SZ"
        case .Sweden: return "SE"
        case .Switzerland: return "CH"
        case .Syria: return "SY"
        case .Taiwan: return "TW"
        case .Tajikistan: return "TJ"
        case .Tanzania: return "TZ"
        case .Thailand: return "TH"
        case .Togo: return "TG"
        case .Tokelau: return "TK"
        case .Tonga: return "TO"
        case .TrinidadandTobago: return "TT"
        case .Tunisia: return "TN"
        case .Turkey: return "TR"
        case .Turkmenistan: return "TM"
        case .TurksandCaicosIslands: return "TC"
        case .Tuvalu: return "TV"
        case .Uganda: return "UG"
        case .Ukraine: return "UA"
        case .UnitedArabEmirates: return "AE"
        case .UnitedKingdom: return "GB"
        case .UnitedStates: return "US"
        case .Uruguay: return "UY"
        case .Uzbekistan: return "UZ"
        case .Vanuatu: return "VU"
        case .VaticanCity: return "VA"
        case .Venezuela: return "VE"
        case .Vietnam: return "VN"
        case .VirginIslandsBritish: return "VG"
        case .WallisandFutuna: return "WF"
        case .WesternSahara: return "EH"
        case .Yemen: return "YE"
        case .Zambia: return "ZM"
        case .Zimbabwe: return "ZW"
        }
    }
    
    static var all: [Country] =
        [.UnitedStates, .Afghanistan, .ÅlandIslands, .Albania, .Algeria,
         .Andorra, .Angola, .Anguilla, .AntiguaandBarbuda, .Argentina, .Armenia,
         .Aruba, .Australia, .Austria, .Azerbaijan, .Bahamas, .Bahrain,
         .Bangladesh, .Barbados, .Belarus, .Belgium, .Belize, .Benin, .Bermuda,
         .Bhutan, .Bolivia, .BosniaandHerzegovina, .Botswana, .Brazil,
         .BritishIndianOceanTerritory, .Brunei, .Bulgaria, .BurkinaFaso,
         .Burundi, .Cambodia, .Cameroon, .Canada, .CapeVerde, .CaymanIslands,
         .CentralAfricanRepublic, .Chad, .Chile, .China, .ChristmasIsland,
         .Colombia, .Comoros, .Congo, .CookIslands, .CostaRica, .CoteDIvoire,
         .Croatia, .Cuba, .Cyprus, .CzechRepublic, .DemocraticRepublicoftheCongo,
         .Denmark, .Djibouti, .Dominica, .DominicanRepublic, .EastTimor,
         .Ecuador, .Egypt, .ElSalvador, .EquatorialGuinea, .Eritrea, .Estonia,
         .Ethiopia, .FalklandIslands, .FaroeIslands, .Fiji, .Finland, .France,
         .FrenchGuiana, .FrenchPolynesia, .FrenchSouthernTerritories, .Gabon,
         .Gambia, .Georgia, .Germany, .Ghana, .Gibraltar, .Greece, .Greenland,
         .Grenada, .Guadeloupe, .Guatemala, .Guernsey, .Guinea, .GuineaBissau,
         .Guyana, .Haiti, .Honduras, .HongKong, .Hungary, .Iceland, .India,
         .Indonesia, .Iran, .Iraq, .Ireland, .IsleofMan, .Israel, .Italy,
         .Jamaica, .Japan, .Jersey, .Jordan, .Kazakhstan, .Kenya, .Kiribati,
         .Kuwait, .Kyrgyzstan, .Laos, .Latvia, .Lebanon, .Lesotho, .Liberia,
         .Libya, .Liechtenstein, .Lithuania, .Luxembourg, .Macao, .Macedonia,
         .Madagascar, .Malawi, .Malaysia, .Maldives, .Mali, .Malta, .Martinique,
         .Mauritania, .Mauritius, .Mayotte, .Mexico, .Moldova, .Monaco,
         .Mongolia, .Montserrat, .Morocco, .Mozambique, .Myanmar, .Namibia,
         .Nauru, .Nepal, .Netherlands, .NetherlandsAntilles, .NewCaledonia,
         .NewZealand, .Nicaragua, .Niger, .Nigeria, .Niue, .NorfolkIsland,
         .NorthKorea, .Norway, .Oman, .Pakistan, .Palestine, .Panama,
         .PapuaNewGuinea, .Paraguay, .Peru, .Philippines, .Pitcairn, .Poland,
         .Portugal, .Qatar, .Reunion, .Romania, .Russia, .Rwanda, .SaintHelena,
         .SaintKittsandNevis, .SaintLucia, .SaintPierreandMiquelon,
         .SaintVincentandtheGrenadines, .Samoa, .SanMarino, .SaoTomeandPrincipe,
         .SaudiArabia, .Senegal, .SerbiaandMontenegro, .Seychelles, .SierraLeone,
         .Singapore, .Slovakia, .Slovenia, .SolomonIslands, .Somalia,
         .SouthAfrica, .SouthKorea, .Spain, .SriLanka, .Sudan, .Suriname,
         .Svalbard, .Swaziland, .Sweden, .Switzerland, .Syria, .Taiwan,
         .Tajikistan, .Tanzania, .Thailand, .Togo, .Tokelau, .Tonga,
         .TrinidadandTobago, .Tunisia, .Turkey, .Turkmenistan,
         .TurksandCaicosIslands, .Tuvalu, .Uganda, .Ukraine, .UnitedArabEmirates,
         .UnitedKingdom, .Uruguay, .Uzbekistan, .VaticanCity, .Vanuatu,
         .Venezuela, .Vietnam, .VirginIslandsBritish, .WallisandFutuna,
         .WesternSahara, .Yemen, .Zambia, .Zimbabwe]
}
