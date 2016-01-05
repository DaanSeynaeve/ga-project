%
% ObjVal = tspfun(Phen, Dist)
% Implementation of the TSP fitness function
%	Phen contains the phenocode of the matrix coded in path
%	representation
%	Dist is the matrix with precalculated distances between each pair of cities
%	ObjVal is a vector with the fitness values for each candidate tour (=each row of Phen)
%

function ObjVal = tspfun_path(Phen, Dist);
	ObjVal = zeros(size(Phen,1),0);
    for i=1:size(Phen,1)
        ObjVal(i,1) = Dist(Phen(i,size(Phen,2)),Phen(i,1));
        for j=1:size(Phen,2)-1
            ObjVal(i,1) = ObjVal(i,1) + Dist(Phen(i,j),Phen(i,j+1));
        end
    end
end


% End of function