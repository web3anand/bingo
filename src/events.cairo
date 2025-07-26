use starknet::ContractAddress;

// Events emitted by the Bingo game.  Off-chain indexers can listen for
// these to drive the UI in real time.

/// Emitted when the host calls a number.  Contains the game ID and the
/// number that was called.
#[derive(Event, Drop, Serde, SerdeLen)]
struct NumberCalled {
    game_id: u128,
    number: u8,
}

/// Emitted when a player joins a game.  Includes the game ID and the
/// joining player’s address.
#[derive(Event, Drop, Serde, SerdeLen)]
struct PlayerJoined {
    game_id: u128,
    player: ContractAddress,
}

/// Emitted when a player wins the game by completing five lines (rows or
/// columns).  Contains the game ID and the winner’s address.
#[derive(Event, Drop, Serde, SerdeLen)]
struct GameWon {
    game_id: u128,
    winner: ContractAddress,
}
