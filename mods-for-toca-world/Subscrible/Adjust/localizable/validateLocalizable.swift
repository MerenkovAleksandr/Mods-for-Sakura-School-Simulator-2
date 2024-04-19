//  Created by Systems
//

import Foundation


func localizedString_MTW(forKey key: String) -> String {
    var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)

    if result == key {
        result = Bundle.main.localizedString(forKey: key, value: nil, table: "Localizable")
    }

    return result
}
