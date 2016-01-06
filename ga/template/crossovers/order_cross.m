% Order crossover for the TSP problem
% Crossover operator for the path representation

function NewChrom = order_cross(OldChrom, x_probability)
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

        % Search for the index of the elements of the second parent that have
        % not been copied yet
        indexes_elements = [];
        for i=1:length(OldChrom(2,:))
            if isempty(find(offspring1==OldChrom(2,i)))
                indexes_elements = [indexes_elements i];
            end
        end

        % Order the index matrix in the order to copy
        % Not necessary if the second crossover point is equal to the length of
        % the second parent

        % Determine the index of the element to copy first
        % Order indexes_elements
        if ~isempty(indexes_elements)
            if (cross_over_points(2)~=length(OldChrom(2,:))) ...
                    && (max(indexes_elements)>cross_over_points(2))
                start_index = min(indexes_elements(...
                    find((indexes_elements>cross_over_points(2))==1)));
                indexes_elements = circshift(indexes_elements,...
                    [0,(length(indexes_elements)+1)-find(indexes_elements==start_index)]);
            end
            % Copy the elements to child one in the order determined of
            % indexes_elements
            if (cross_over_points(2)~=length(OldChrom(2,:)))
                counter = cross_over_points(2)+1;
                for i=indexes_elements
                    if counter == length(OldChrom(2,:))
                        NewChrom(1,counter) = OldChrom(2,i);
                        counter = 1;
                    else
                        NewChrom(1,counter) = OldChrom(2,i);
                        counter = counter+1;
                    end
                end
            else
                for i=1:cross_over_points(1)-1
                    NewChrom(1,i) = OldChrom(2,indexes_elements(i));
                end
            end
        end

        % analogous for the second child

        indexes_elements = [];
        for i=1:length(OldChrom(1,:))
            if isempty(find(offspring2==OldChrom(1,i)))
                indexes_elements = [indexes_elements i];
            end
        end

        if ~isempty(indexes_elements)
            if (cross_over_points(2)~=length(OldChrom(1,:))) && ...
                    (max(indexes_elements)>cross_over_points(2))
                start_index = min(indexes_elements(...
                    find((indexes_elements>cross_over_points(2))==1)));
                indexes_elements = circshift(indexes_elements,...
                    [0,(length(indexes_elements)+1)-find(indexes_elements==start_index)]);
            end
            if (cross_over_points(2)~=length(OldChrom(1,:)))
                counter = cross_over_points(2)+1;
                for i=indexes_elements
                    if counter == length(OldChrom(1,:))
                        NewChrom(2,counter) = OldChrom(1,i);
                        counter = 1;
                    else
                        NewChrom(2,counter) = OldChrom(1,i);
                        counter = counter+1;
                    end
                end
            else
                for i=1:cross_over_points(1)-1
                    NewChrom(2,i) = OldChrom(1,indexes_elements(i));
                end
            end
        end
    else
        NewChrom = OldChrom;
    end
end