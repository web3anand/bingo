use starknet::ContractAddress;
use dojo::storage::world::{get_component, set_component, emit_event};
use array::{Array, ArrayTrait};

use crate::components::{Player, Game};
use crate::events::{NumberCalled, PlayerJoined, GameWon};

/// Register a new player with a unique username hash.  The front-end should
/// compute `username_hash` as a keccak256 of the user’s chosen name.  This
/// function creates a `Player` component keyed by the caller’s address.
///
/// Arguments:
/// - `address`: the Starknet account address of the player.
/// - `username_hash`: keccak hash of the username to prevent duplicates.
#[system]
fn register(address: ContractAddress, username_hash: felt252) {
    // Initialize empty board and marks arrays.  The board will be populated
    // when the player joins a game.  We allocate them here so that the
    // component has predictable fields.
    let mut board: Array<u8> = ArrayTrait::new();
    let mut marks: Array<bool> = ArrayTrait::new();
    // Construct and save the player component.  game_id = 0 indicates no
    // active game.  bingo_letters = 0 since the player hasn’t completed any
    // rows or columns.
    let player = Player {
        address,
        username_hash,
        game_id: 0,
        board,
        marks,
        bingo_letters: 0_u8,
    };
    set_component::<Player>(address, player);
}

/// Create a new game with the supplied `game_id`.  The caller becomes the
/// host and an empty list of players is initialized.  A separate call to
/// `join_game` is required for the host to add themselves to the game.
#[system]
fn create_game(game_id: u128, host: ContractAddress) {
    let players: Array<ContractAddress> = ArrayTrait::new();
    let game = Game {
        id: game_id,
        host,
        players,
        current_number: 0_u8,
        finished: false,
    };
    set_component::<Game>(game_id, game);
}

/// Join an existing game.  Adds the caller to the game’s player list and
/// updates the caller’s `game_id` field.  Emits a `PlayerJoined` event.
#[system]
fn join_game(game_id: u128, player_addr: ContractAddress) {
    // Fetch the game and append the caller to the player list.
    let (mut game) = get_component::<Game>(game_id);
    // Note: In production, check `game.finished` and the number of players.
    game.players.append(player_addr);
    set_component::<Game>(game_id, game);
    // Update the player’s game_id.  We assume the player component exists.
    let (mut player) = get_component::<Player>(player_addr);
    player.game_id = game_id;
    set_component::<Player>(player_addr, player);
    // Emit event for off-chain listeners.
    emit_event(PlayerJoined { game_id, player: player_addr });
}

/// Start a game.  Only the host may call this function.  Assigns boards to
/// each player consisting of the numbers 1–25 in order and initializes
/// their marks and bingo_letters.  In a production game you would use
/// randomness to shuffle boards.
#[system]
fn start_game(game_id: u128, caller: ContractAddress) {
    let (mut game) = get_component::<Game>(game_id);
    // Only allow the host to start the game.
    assert!(caller == game.host, 'Only host may start');
    // Iterate through the list of players and assign boards.
    let player_count = game.players.len();
    let mut i: u32 = 0;
    while i < player_count {
        let player_addr = game.players[i];
        // Fetch the player component.
        let (mut player) = get_component::<Player>(player_addr);
        // Initialize board with numbers 1–25.  Note: no randomness used.
        let mut board: Array<u8> = ArrayTrait::new();
        let mut marks: Array<bool> = ArrayTrait::new();
        let mut j: u32 = 0;
        while j < 25 {
            board.append((j + 1) as u8);
            marks.append(false);
            j += 1;
        }
        player.board = board;
        player.marks = marks;
        player.bingo_letters = 0_u8;
        set_component::<Player>(player_addr, player);
        i += 1;
    }
    // Reset current number and finished flag.
    game.current_number = 0_u8;
    game.finished = false;
    set_component::<Game>(game_id, game);
}

/// Host calls a number.  This updates the game state, marks player boards,
/// checks for winners and emits the appropriate events.  For brevity, the
/// bingo checking logic here only increments bingo_letters when the
/// `number` is found; it does not verify full rows/columns.  In a
/// production implementation you would scan the marks array for completed
/// lines.
#[system]
fn call_number(game_id: u128, caller: ContractAddress, number: u8) {
    let (mut game) = get_component::<Game>(game_id);
    // Only the host may call numbers and the game must not be finished.
    assert!(caller == game.host, 'Only host may call');
    assert!(!game.finished, 'Game finished');
    game.current_number = number;
    set_component::<Game>(game_id, game);
    emit_event(NumberCalled { game_id, number });
    // Iterate through players, mark boards and update bingo_letters.
    let player_count = game.players.len();
    let mut i: u32 = 0;
    while i < player_count {
        let addr = game.players[i];
        let (mut player) = get_component::<Player>(addr);
        // Find the number on the board and mark it.
        let mut idx: u32 = 0;
        while idx < player.board.len() {
            if player.board[idx] == number {
                player.marks[idx] = true;
                // Increment bingo_letters as a placeholder for real bingo
                // detection logic.  This means a player will win after
                // matching 5 numbers.
                player.bingo_letters += 1_u8;
                break;
            }
            idx += 1;
        }
        // Check win condition (5 letters) and finish game.
        if player.bingo_letters >= 5_u8 {
            let (mut game_fin) = get_component::<Game>(game_id);
            game_fin.finished = true;
            set_component::<Game>(game_id, game_fin);
            emit_event(GameWon { game_id, winner: addr });
        }
        set_component::<Player>(addr, player);
        i += 1;
    }
}
