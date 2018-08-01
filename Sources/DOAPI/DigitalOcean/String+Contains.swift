import Foundation

extension String {
    
    func contains(only: CharacterSet) -> Bool {
        return unicodeScalars.first { !only.contains($0) } == nil
    }
    
    func containing(only: CharacterSet) -> String {
        return String(unicodeScalars.filter(only.contains))
    }
    
}
