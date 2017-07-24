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
    
    static func from(code: String) -> Country? {
        switch code.uppercased() {
        case "AF": return .Afghanistan
        case "AX": return .ÅlandIslands
        case "AL": return .Albania
        case "DZ": return .Algeria
        case "AD": return .Andorra
        case "AO": return .Angola
        case "AI": return .Anguilla
        case "AG": return .AntiguaandBarbuda
        case "AR": return .Argentina
        case "AM": return .Armenia
        case "AW": return .Aruba
        case "AU": return .Australia
        case "AT": return .Austria
        case "AZ": return .Azerbaijan
        case "BS": return .Bahamas
        case "BH": return .Bahrain
        case "BD": return .Bangladesh
        case "BB": return .Barbados
        case "BY": return .Belarus
        case "BE": return .Belgium
        case "BZ": return .Belize
        case "BJ": return .Benin
        case "BM": return .Bermuda
        case "BT": return .Bhutan
        case "BO": return .Bolivia
        case "BA": return .BosniaandHerzegovina
        case "BW": return .Botswana
        case "BR": return .Brazil
        case "IO": return .BritishIndianOceanTerritory
        case "BN": return .Brunei
        case "BG": return .Bulgaria
        case "BF": return .BurkinaFaso
        case "BI": return .Burundi
        case "KH": return .Cambodia
        case "CM": return .Cameroon
        case "CA": return .Canada
        case "CV": return .CapeVerde
        case "KY": return .CaymanIslands
        case "CF": return .CentralAfricanRepublic
        case "TD": return .Chad
        case "CL": return .Chile
        case "CN": return .China
        case "CX": return .ChristmasIsland
        case "CC": return .CocosIslands
        case "CO": return .Colombia
        case "KM": return .Comoros
        case "CG": return .Congo
        case "CK": return .CookIslands
        case "CR": return .CostaRica
        case "CI": return .CoteDIvoire
        case "HR": return .Croatia
        case "CU": return .Cuba
        case "CY": return .Cyprus
        case "CZ": return .CzechRepublic
        case "CD": return .DemocraticRepublicoftheCongo
        case "DK": return .Denmark
        case "DJ": return .Djibouti
        case "DM": return .Dominica
        case "DO": return .DominicanRepublic
        case "TL": return .EastTimor
        case "EC": return .Ecuador
        case "EG": return .Egypt
        case "SV": return .ElSalvador
        case "GQ": return .EquatorialGuinea
        case "ER": return .Eritrea
        case "EE": return .Estonia
        case "ET": return .Ethiopia
        case "FK": return .FalklandIslands
        case "FO": return .FaroeIslands
        case "FJ": return .Fiji
        case "FI": return .Finland
        case "FR": return .France
        case "GF": return .FrenchGuiana
        case "PF": return .FrenchPolynesia
        case "TF": return .FrenchSouthernTerritories
        case "GA": return .Gabon
        case "GM": return .Gambia
        case "GE": return .Georgia
        case "DE": return .Germany
        case "GH": return .Ghana
        case "GI": return .Gibraltar
        case "GR": return .Greece
        case "GL": return .Greenland
        case "GD": return .Grenada
        case "GP": return .Guadeloupe
        case "GT": return .Guatemala
        case "GG": return .Guernsey
        case "GN": return .Guinea
        case "GW": return .GuineaBissau
        case "GY": return .Guyana
        case "HT": return .Haiti
        case "HN": return .Honduras
        case "HK": return .HongKong
        case "HU": return .Hungary
        case "IS": return .Iceland
        case "IN": return .India
        case "ID": return .Indonesia
        case "IR": return .Iran
        case "IQ": return .Iraq
        case "IE": return .Ireland
        case "IM": return .IsleofMan
        case "IL": return .Israel
        case "IT": return .Italy
        case "JM": return .Jamaica
        case "JP": return .Japan
        case "JE": return .Jersey
        case "JO": return .Jordan
        case "KZ": return .Kazakhstan
        case "KE": return .Kenya
        case "KI": return .Kiribati
        case "KW": return .Kuwait
        case "KG": return .Kyrgyzstan
        case "LA": return .Laos
        case "LV": return .Latvia
        case "LB": return .Lebanon
        case "LS": return .Lesotho
        case "LR": return .Liberia
        case "LY": return .Libya
        case "LI": return .Liechtenstein
        case "LT": return .Lithuania
        case "LU": return .Luxembourg
        case "MO": return .Macao
        case "MK": return .Macedonia
        case "MG": return .Madagascar
        case "MW": return .Malawi
        case "MY": return .Malaysia
        case "MV": return .Maldives
        case "ML": return .Mali
        case "MT": return .Malta
        case "MQ": return .Martinique
        case "MR": return .Mauritania
        case "MU": return .Mauritius
        case "KP": return .NorthKorea
        case "YT": return .Mayotte
        case "MX": return .Mexico
        case "MD": return .Moldova
        case "MC": return .Monaco
        case "MN": return .Mongolia
        case "MS": return .Montserrat
        case "MA": return .Morocco
        case "MZ": return .Mozambique
        case "MM": return .Myanmar
        case "NA": return .Namibia
        case "NR": return .Nauru
        case "NP": return .Nepal
        case "NL": return .Netherlands
        case "AN": return .NetherlandsAntilles
        case "NC": return .NewCaledonia
        case "NZ": return .NewZealand
        case "NI": return .Nicaragua
        case "NE": return .Niger
        case "NG": return .Nigeria
        case "NU": return .Niue
        case "NF": return .NorfolkIsland
        case "NO": return .Norway
        case "OM": return .Oman
        case "PK": return .Pakistan
        case "PS": return .Palestine
        case "PA": return .Panama
        case "PG": return .PapuaNewGuinea
        case "PY": return .Paraguay
        case "PE": return .Peru
        case "PH": return .Philippines
        case "PN": return .Pitcairn
        case "PL": return .Poland
        case "PT": return .Portugal
        case "QA": return .Qatar
        case "RE": return .Reunion
        case "RO": return .Romania
        case "RU": return .Russia
        case "RW": return .Rwanda
        case "SH": return .SaintHelena
        case "KN": return .SaintKittsandNevis
        case "LC": return .SaintLucia
        case "PM": return .SaintPierreandMiquelon
        case "VC": return .SaintVincentandtheGrenadines
        case "WS": return .Samoa
        case "SM": return .SanMarino
        case "ST": return .SaoTomeandPrincipe
        case "SA": return .SaudiArabia
        case "SN": return .Senegal
        case "CS": return .SerbiaandMontenegro
        case "SC": return .Seychelles
        case "SL": return .SierraLeone
        case "SG": return .Singapore
        case "SK": return .Slovakia
        case "SI": return .Slovenia
        case "SB": return .SolomonIslands
        case "SO": return .Somalia
        case "ZA": return .SouthAfrica
        case "KR": return .SouthKorea
        case "ES": return .Spain
        case "LK": return .SriLanka
        case "SD": return .Sudan
        case "SR": return .Suriname
        case "SJ": return .Svalbard
        case "SZ": return .Swaziland
        case "SE": return .Sweden
        case "CH": return .Switzerland
        case "SY": return .Syria
        case "TW": return .Taiwan
        case "TJ": return .Tajikistan
        case "TZ": return .Tanzania
        case "TH": return .Thailand
        case "TG": return .Togo
        case "TK": return .Tokelau
        case "TO": return .Tonga
        case "TT": return .TrinidadandTobago
        case "TN": return .Tunisia
        case "TR": return .Turkey
        case "TM": return .Turkmenistan
        case "TC": return .TurksandCaicosIslands
        case "TV": return .Tuvalu
        case "UG": return .Uganda
        case "UA": return .Ukraine
        case "AE": return .UnitedArabEmirates
        case "GB": return .UnitedKingdom
        case "US": return .UnitedStates
        case "UY": return .Uruguay
        case "UZ": return .Uzbekistan
        case "VU": return .Vanuatu
        case "VA": return .VaticanCity
        case "VE": return .Venezuela
        case "VN": return .Vietnam
        case "VG": return .VirginIslandsBritish
        case "WF": return .WallisandFutuna
        case "EH": return .WesternSahara
        case "YE": return .Yemen
        case "ZM": return .Zambia
        case "ZW": return .Zimbabwe
        default: return nil
        }
    }
    
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
