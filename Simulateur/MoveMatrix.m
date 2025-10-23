% function for moving matrices
function newCenterMatrix = MoveMatrix(matrix, distVector)
    % S = S_(distVector);
    % H = [eye(3) S.';
    %     zeros(3) eye(3)];
    newCenterMatrix = H_(distVector).' * matrix * H_(distVector);
end

