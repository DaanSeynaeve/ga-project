% Partially mapped crossover for the TSP problem
% Crossover operator for the path representation

function NewChrom = partially_mapped_cross(OldChrom, x_probability)
    if nargin<2
        x_probability = 1;
    end
    if rand<x_probability
        % select 2 random crossover points and take the segments between those
        % points in the parents as offspring
        NewChrom = zeros(2,length(OldChrom(1,:)));
        cross_over_points = randi([1,length(OldChrom(1,:))],1,2);
        if cross_over_points(1) > cross_over_points(2)
            cross_over_points = flip(cross_over_points);
        end
        offspring1 = OldChrom(1,cross_over_points(1):cross_over_points(2));
        offspring2 = OldChrom(2,cross_over_points(1):cross_over_points(2));
        NewChrom(1,cross_over_points(1):cross_over_points(2)) = offspring1;
        NewChrom(2,cross_over_points(1):cross_over_points(2)) = offspring2;

        % Find the elements of the offspring of the second parent that have not been copied yet
        elements_to_copy = [];
        for i=1:length(offspring2)
            if isempty(find(offspring1==offspring2(i)))
                elements_to_copy = [elements_to_copy offspring2(i)];
            end
        end
        % Search for the corresponding element in the offspring of the first
        % parent for eacht element in elements_to_copy
        % Search for the index of that element in the second parent and put the
        % element i of elements_to_copy in that position in child 1
        % if that position in child one is already taken repeat this procedure
        for i=1:length(elements_to_copy)
            index = find(offspring2 == elements_to_copy(i));
            element_copied_instead = offspring1(index);
            index_parent2 = find(OldChrom(2,:)==element_copied_instead);
            while NewChrom(1,index_parent2) ~= 0
                element_copied_instead = NewChrom(1,index_parent2);
                index_parent2 = find(OldChrom(2,:)==element_copied_instead);
            end
            NewChrom(1,index_parent2) = elements_to_copy(i);
        end
        % copy the remaining elements to child 1
        positions_still_zero = find(NewChrom(1,:)==0);
        for i=1:length(positions_still_zero)
            NewChrom(1,positions_still_zero(i)) = OldChrom(2,positions_still_zero(i));
        end

        % analogous for the second child
        elements_to_copy = [];
        for i=1:length(offspring1)
            if isempty(find(offspring2==offspring1(i)))
                elements_to_copy = [elements_to_copy offspring1(i)];
            end
        end
        for i=1:length(elements_to_copy)
            index = find(offspring1 == elements_to_copy(i));
            element_copied_instead = offspring2(index);
            index_parent1 = find(OldChrom(1,:)==element_copied_instead);
            while NewChrom(2,index_parent1) ~= 0
                element_copied_instead = NewChrom(2,index_parent1);
                index_parent1 = find(OldChrom(1,:)==element_copied_instead);
            end
            NewChrom(2,index_parent1) = elements_to_copy(i);
        end
        positions_still_zero = find(NewChrom(2,:)==0);
        for i=1:length(positions_still_zero)
            NewChrom(2,positions_still_zero(i)) = OldChrom(1,positions_still_zero(i));
        end
    else
        NewChrom = OldChrom;
    end
end