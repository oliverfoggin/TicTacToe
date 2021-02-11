import SwiftUI
import ComposableArchitecture
import Engine

@main
struct TicTacToeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: TicTacToeState(),
                    reducer: gameReducer,
                    environment: .live()
                )
            )
        }
    }
}
