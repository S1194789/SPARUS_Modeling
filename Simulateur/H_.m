function H_Matrix = H_(distVector)
    % This matrix is used later to move matrices
    % to different center
    S = S_(distVector);
    H_Matrix = [eye(3) S.';
                zeros(3) eye(3)];
end

