import Foundation
import ComposableArchitecture

public enum Player: String, Equatable {
    case x
    case o
    case none
}

public enum GameStatus: Equatable {
    case active
    case tie
    case winner(Player)
}

public struct TicTacToeState: Equatable {
    public var currentPlayer: Player = .x
    public var board: [[Player]] = TicTacToeState.emptyBoard
    public var status = GameStatus.active
    public var alert: AlertState<GameAction>?
    
    public static let emptyBoard: [[Player]] = [[.none, .none, .none], [.none, .none, .none], [.none, .none, .none]]
    
    public init(
        currentPlayer: Player = .x,
        board: [[Player]] = TicTacToeState.emptyBoard,
        status: GameStatus = .active,
        alert: AlertState<GameAction>? = nil
    ) {
        self.currentPlayer = currentPlayer
        self.board = board
        self.status = status
        self.alert = alert
    }
    
    func checkForWinner(board: [[Player]]) -> Player {
        let winStates = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [2, 4, 6]
        ]
        
        return winStates.map { cells in
            let players = cells.map {
                board[$0 % 3][$0 / 3]
            }
            
            if players.allSatisfy({ $0 == .x }) {
                return .x
            }
            
            if players.allSatisfy({ $0 == .o }) {
                return .o
            }
            
            return nil
        }
        .compactMap { $0 }
        .first ?? Player.none
    }
    
    func isTie(board: [[Player]]) -> Bool {
        if checkForWinner(board: board) != .none {
            return false
        }
        
        return board.flatMap { $0 }
            .filter { $0 == Player.none }
            .count == 0
    }
}

public enum GameAction: Equatable {
    case play(col: Int, row: Int)
    case alertDismissed
    case newGameTapped
}

public struct GameEnvironment {}

public extension GameEnvironment {
    static func live() -> Self {
        return GameEnvironment()
    }
}

public let gameReducer = Reducer<TicTacToeState, GameAction, GameEnvironment> { state, action, environment in
    switch action {
    case let .play(col: col, row: row):
        guard state.status == .active else {
            state.alert = .init(
                title: .init("The game is over"),
                dismissButton: .default(.init("New game"), send: .newGameTapped)
            )
            return .none
        }
        
        if state.board[col][row] != .none {
            state.alert = .init(
                title: .init("That space is taken, pick an empty space."),
                dismissButton: .default(.init("OK"), send: .alertDismissed)
            )
            return .none
        }
        
        state.board[col][row] = state.currentPlayer
        state.currentPlayer = state.currentPlayer == .x ? .o : .x
        
        let winner = state.checkForWinner(board: state.board)
        
        if winner != Player.none {
            state.status = .winner(winner)
            state.alert = .init(
                title: .init("The winner is \(winner.rawValue)"),
                dismissButton: .default(.init("New game"), send: .newGameTapped)
            )
            return .none
        }
        
        if state.isTie(board: state.board) {
            state.status = .tie
            state.alert = .init(
                title: .init("The game ended in a tie."),
                dismissButton: .default(.init("New game"), send: .newGameTapped)
            )
            return .none
        }
        
        return .none
        
    case .alertDismissed:
        return .none
        
    case .newGameTapped:
        state = TicTacToeState()
        return .none
    }
}
