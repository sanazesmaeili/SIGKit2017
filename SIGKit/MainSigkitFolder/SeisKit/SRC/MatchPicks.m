function [ XRec ] = MatchPicks( X,RecXPos )
%MatchPicks finds the geophone nearest in position to the X position
%clicked by the user
%Input arguments
%
%X = a vector of X positions clicked
%RecXpos = a vector of receiver positions as set up during the survey
%
%Output Arguments
%XRec = Receiver positions that is the shortest distance away from the X
%position clicked by the user

I = zeros(1,length(X));

for i = 1:length(X)
    [~, I(i)] = min(abs(X(i)-RecXPos));
end
XRec = RecXPos(I);

end

