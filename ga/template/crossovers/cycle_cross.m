% Cycle crossover for the TSP problem
% Crossover operator for the path representation

function NewChrom = cycle_cross(OldChrom, x_probability)
    if nargin<2
        x_probability = 1;
    end
    if rand<x_probability
        parent1 = OldChrom(1,:);
        parent2 = OldChrom(2,:);

        % construct a cycle and use it as offspring
        start_cycle = parent1(1);
        next_in_cycle = parent2(1);
        child1 = [start_cycle zeros(1,length(parent1)-1)];
        child2 = [next_in_cycle zeros(1,length(parent2)-1)];

        while next_in_cycle ~= parent1(1)
            index_other_parent = find(parent1 == next_in_cycle);
            child1(index_other_parent) = next_in_cycle;
            next_in_cycle = parent2(index_other_parent);
            child2(index_other_parent) = next_in_cycle;
        end

        % exchange the elements that are not copied yet
        positions_zero = find(child1==0);
        for i=positions_zero
            child1(i) = parent2(i);
            child2(i) = parent1(i);
        end

        NewChrom(1,:) = child1;
        NewChrom(2,:) = child2;
    else
        NewChrom = OldChrom;
    end
end