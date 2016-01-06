% Sequential Constructive crossover for TSP (Zakir H. Ahmed, 2010)
% this crossover assumes that the path representation is used to represent
% TSP tours
%
% Daan Seynaeve 2015
%
%
% Syntax:  NewChrom = scx(OldChrom,Cost)
%
% Input parameters:
%    OldChrom  - Matrix containing the chromosomes of the old
%                population. Each line corresponds to one individual
%                (in any form, not necessarily real values).
%
%    Cost      - Cost matrix. Cost(i,j) corresponds to the cost between
%                the node i and the node j
%
% Output parameter:
%    NewChrom  - Matrix containing the chromosomes of the population
%                after mating, ready to be mutated and/or evaluated,
%                in the same format as OldChrom.
function NewChrom = scx(oldChrom,Cost,x_probability)
    if nargin < 3
        x_probability = 1;
    end
    if rand<x_probability
        n = size(oldChrom,2);
        child1 = zeros(1,n);
        legit = ones(1,n);

        parent1 = oldChrom(1,:);
        parent2 = oldChrom(2,:);

        nci = 1;
        child1(1) = 1;
        legit(1) = 0;
        while nci < n
            p = child1(nci);
            nci = nci + 1;

            alfa = 0;
            beta = 0;

            for i = 1:n-1
                if parent1(i) == p && legit(parent1(i+1))
                    alfa = parent1(i + 1);
                end
                if parent2(i) == p && legit(parent2(i+1))
                    beta = parent2(i + 1);
                end
            end

            if alfa == 0 || beta == 0
                % find a legit k
                k = 2;
                while not(legit(k))
                    k = k + 1;
                end

                if beta == 0 && alfa == 0
                    beta = k;
                    alfa = k;
                elseif beta == 0
                    beta = k;
                else
                    alfa = k;
                end
            end
            if Cost(p,alfa) < Cost(p,beta)
                child1(nci) = alfa;
            else
                child1(nci) = beta;
            end
            legit(child1(nci)) = 0;
        end
        NewChrom = [parent1; child1];
    else
        NewChrom = oldChrom;
    end

end