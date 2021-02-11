import XCTest
import ComposableArchitecture
@testable import Engine

class EngineTests: XCTestCase {
    func testGameFlowHappyPath() {
        let testStore = TestStore(
            initialState: TicTacToeState(),
            reducer: gameReducer,
            environment: GameEnvironment()
        )
        
        testStore.assert(
            .send(.play(col: 1, row: 1)) {
                $0.board[1][1] = .x
                $0.currentPlayer = .o
            },
            .send(.play(col: 1, row: 2)) {
                $0.board[1][2] = .o
                $0.currentPlayer = .x
            },
            .send(.play(col: 0, row: 0)) {
                $0.board[0][0] = .x
                $0.currentPlayer = .o
            },
            .send(.play(col: 0, row: 1)) {
                $0.board[0][1] = .o
                $0.currentPlayer = .x
            },
            .send(.play(col: 2, row: 2)) {
                $0.board[2][2] = .x
                $0.currentPlayer = .o
                $0.status = .winner(.x)
                $0.alert = .init(
                    title: .init("The winner is x"),
                    dismissButton: .default(.init("New game"), send: .newGameTapped)
                )
            }
        )
    }
    
    func testGameFlowUnhappyPath() {
        let testStore = TestStore(
            initialState: TicTacToeState(),
            reducer: gameReducer,
            environment: GameEnvironment()
        )
        
        testStore.assert(
            .send(.play(col: 1, row: 1)) {
                $0.board[1][1] = .x
                $0.currentPlayer = .o
            },
            .send(.play(col: 1, row: 2)) {
                $0.board[1][2] = .o
                $0.currentPlayer = .x
            },
            .send(.play(col: 1, row: 2)) {
                $0.alert = .init(
                    title: .init("That space is taken, pick an empty space."),
                    dismissButton: .default(.init("OK"), send: .alertDismissed)
                )
            },
            .send(.alertDismissed),
            .send(.play(col: 2, row: 1)) {
                $0.board[2][1] = .x
                $0.currentPlayer = .o
            },
            .send(.play(col: 0, row: 0)) {
                $0.board[0][0] = .o
                $0.currentPlayer = .x
            },
            .send(.play(col: 0, row: 1)) {
                $0.board[0][1] = .x
                $0.currentPlayer = .o
                $0.status = .winner(.x)
                $0.alert = .init(
                    title: .init("The winner is x"),
                    dismissButton: .default(.init("New game"), send: .newGameTapped)
                )
            },
            .send(.play(col: 2, row: 2)) {
                $0.alert = .init(
                    title: .init("The game is over"),
                    dismissButton: .default(.init("New game"), send: .newGameTapped)
                )
            },
            .send(.alertDismissed),
            .send(.newGameTapped) {
                $0.board = TicTacToeState.emptyBoard
                $0.currentPlayer = .x
                $0.status = .active
                $0.alert = nil
            },
            .send(.play(col: 1, row: 1)) {
                $0.board[1][1] = .x
                $0.currentPlayer = .o
            },
            .send(.play(col: 0, row: 2)) {
                $0.board[0][2] = .o
                $0.currentPlayer = .x
            },
            .send(.play(col: 2, row: 1)) {
                $0.board[2][1] = .x
                $0.currentPlayer = .o
            },
            .send(.play(col: 0, row: 1)) {
                $0.board[0][1] = .o
                $0.currentPlayer = .x
            },
            .send(.play(col: 2, row: 2)) {
                $0.board[2][2] = .x
                $0.currentPlayer = .o
            },
            .send(.play(col: 0, row: 0)) {
                $0.board[0][0] = .o
                $0.currentPlayer = .x
                $0.status = .winner(.o)
                $0.alert = .init(
                    title: .init("The winner is o"),
                    dismissButton: .default(.init("New game"), send: .newGameTapped)
                )
            }
        )
    }
    
    func testTie() {
        let testStore = TestStore(
            initialState: TicTacToeState(
                currentPlayer: .x,
                board: [
                    [.x, .o, .o],
                    [.o, .x, .none],
                    [.x, .o, .o],
                ]),
            reducer: gameReducer,
            environment: GameEnvironment()
        )
        
        testStore.assert(
            .send(.play(col: 1, row: 2)) {
                $0.board[1][2] = .x
                $0.currentPlayer = .o
                $0.status = .tie
                $0.alert = .init(
                    title: .init("The game ended in a tie."),
                    dismissButton: .default(.init("New game"), send: .newGameTapped)
                )
            }
        )
    }
}
