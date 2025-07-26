use starknet::ContractAddress;
use array::Array;

// Components for the on-chain Bingo game.  We model players and games
// using Dojo’s Entity–Component–System pattern.  Each player has a unique
// address (the Starknet account) and a hashed username.  The board and
// marks arrays represent the 5×5 grid of numbers and whether those
// numbers have been marked.  The bingo_letters field counts how many
// rows or columns the player has completed.

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Player {
    /// The Starknet account address (used as the key).
    #[key] address: ContractAddress,
    /// keccak256 hash of the user’s chosen username.  Used to enforce uniqueness.
    username_hash: felt252,
    /// The ID of the game this player is currently in.  Zero means no game.
    game_id: u128,
    /// A 25-element array representing the player’s Bingo board.  Numbers are
    /// stored as 8-bit values.  Boards are assigned when a game starts.
    board: Array<u8>,
    /// A 25-element array of booleans indicating whether each board number has
    /// been marked.  Initially all false.
    marks: Array<bool>,
    /// The number of completed rows or columns.  When this reaches 5 the
    /// player has spelled BINGO and wins the game.
    bingo_letters: u8,
}

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Game {
    /// Unique identifier for the game.  The game ID is supplied by the host.
    #[key] id: u128,
    /// Address of the player who created the game.  Only the host may start
    /// the game and call numbers.
    host: ContractAddress,
    /// List of players in the game (up to five).  Players join by pushing
    /// their address into this array.
    players: Array<ContractAddress>,
    /// The current number called by the host.  Zero indicates no number has
    /// been called yet.
    current_number: u8,
    /// Set to true when a player wins.  Additional numbers cannot be called
    /// once the game is finished.
    finished: bool,
}
