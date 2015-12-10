function [move_type] = classify_move(board, move, transports, start_pos)

% CLASSIFY_MOVE  determines if the desired move is valid or not, and what type of move/cost it would have.
% 
% Input:
%     board : 2D ndarray of int
%         Board layout
%     move : int
%         Move to be performed
%     transports : 2 element list of 1x2 tuples
%         Location of the transports
%     start_pos : int
%         Starting linearized location of the knight
% 
% Output:
%     move_type : class Move
%         Type of move to be performed
% 
% Prototype:
%     board      = zeros(2,5);
%     move       = 2; % (2 right and 1 down)
%     transports = [];
%     start_pos  = 5;
%     board(start_pos) = PIECE_.current;
%     move_type = classify_move(board, move, transports, start_pos);
%     assert(move_type == MOVE_.normal);
% 
% Change Log:
%     1.  Written by David C. Stauffer in December 2015.

% find the traversal for the desired move
all_pos = get_new_position(size(board), start_pos, move, transports);

% check that the final and intermediate positions were all on the board
if any(isnan(all_pos))
    move_type = MOVE_.off_board;
    return
end

% get the values for each position
p1 = board(all_pos(1));
p2 = board(all_pos(2));
p3 = board(all_pos(3));

% check for error conditions
if p3 == PIECE_.start || p3 == PIECE_.current
    error('knight:InvalidLocation', 'The piece should never be able to move to it''s current or starting position.');
end

% check for blocked conditions
if p3 == PIECE_.rock || p3 == PIECE_.barrier || p1 == PIECE_.barrier || p2 == PIECE_.barrier
    move_type = MOVE_.blocked;
    return
end

% remaining moves are valid, determine type
switch p3
    case PIECE_.visited
        move_type = MOVE_.visited;
    case PIECE_.null
        move_type = MOVE_.normal;
    case PIECE_.final
        move_type = MOVE_.winning;
    case PIECE_.transport
        move_type = MOVE_.transport;
    case PIECE_.water
        move_type = MOVE_.water;
    case PIECE_.lava
        move_type = MOVE_.lava;
    otherwise
        error('knight:BadPieceType', 'Unexpected piece type "%s"',p3);
end