import SwiftUI

protocol DidAppearable {
    var didAppear: ((Self) -> Void)? { get set }
}
