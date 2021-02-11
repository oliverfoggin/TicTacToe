import SwiftUI
import ComposableArchitecture
import Engine

struct ContentView: View {
    let store: Store<TicTacToeState, GameAction>
        
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("Current Player: \(viewStore.currentPlayer.rawValue)")
                VStack {
                    HStack {
                        CellView(label: viewStore.board[0][0]) { viewStore.send(.play(col: 0, row: 0)) }
                        CellView(label: viewStore.board[0][1]) { viewStore.send(.play(col: 0, row: 1)) }
                        CellView(label: viewStore.board[0][2]) { viewStore.send(.play(col: 0, row: 2)) }
                    }
                    HStack {
                        CellView(label: viewStore.board[1][0]) { viewStore.send(.play(col: 1, row: 0)) }
                        CellView(label: viewStore.board[1][1]) { viewStore.send(.play(col: 1, row: 1)) }
                        CellView(label: viewStore.board[1][2]) { viewStore.send(.play(col: 1, row: 2)) }
                    }
                    HStack {
                        CellView(label: viewStore.board[2][0]) { viewStore.send(.play(col: 2, row: 0)) }
                        CellView(label: viewStore.board[2][1]) { viewStore.send(.play(col: 2, row: 1)) }
                        CellView(label: viewStore.board[2][2]) { viewStore.send(.play(col: 2, row: 2)) }
                    }
                }
                .alert(
                  self.store.scope(state: { $0.alert }),
                  dismiss: .alertDismissed
                )
            }
        }
    }
}

struct CellView: View {
    let label: Player
    let action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            ZStack {
                Color.red
                    .frame(width: 100, height: 100, alignment: .center)
                Text("\(label.rawValue)")
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: TicTacToeState(),
                reducer: gameReducer,
                environment: .live()
            )
        )
    }
}
