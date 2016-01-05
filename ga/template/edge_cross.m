% Edge crossover for the TSP problem
% Crossover operator for the path representation

function NewChrom = edge_cross(OldChrom, x_probability)
    if nargin<2
        x_probability = 1;
    end
    if rand<x_probability
        parent1 = OldChrom(1,:);
        parent2 = OldChrom(2,:);

        %% Construct edge table

        for i=1:size(OldChrom,2)
            field = ['city' num2str(i)];
            index_i_parent1 = find(parent1==i);
            index_i_parent2 = find(parent2==i);
            if index_i_parent1 == 1
                if index_i_parent2 == 1
                    edge_table.(field) = [parent1(length(parent1)), parent1(2), parent2(length(parent2)) parent2(2)];
                elseif index_i_parent2 == length(parent2)
                    edge_table.(field) = [parent1(length(parent1)), parent1(2), parent2(index_i_parent2-1) parent2(1)];
                else
                    edge_table.(field) = [parent1(length(parent1)), parent1(2), parent2(index_i_parent2-1) parent2(index_i_parent2+1)];
                end
            elseif index_i_parent1 == length(parent1)
                if index_i_parent2 == 1
                    edge_table.(field) = [parent1(index_i_parent1-1), parent1(1), parent2(length(parent2)) parent2(2)];
                elseif index_i_parent2 == length(parent2)
                    edge_table.(field) = [parent1(index_i_parent1-1), parent1(1), parent2(index_i_parent2-1) parent2(1)];
                else
                    edge_table.(field) = [parent1(index_i_parent1-1), parent1(1), parent2(index_i_parent2-1) parent2(index_i_parent2+1)];
                end
            else
                if index_i_parent2 == 1
                    edge_table.(field) = [parent1(index_i_parent1-1), parent1(index_i_parent1+1), parent2(length(parent2)) parent2(2)];
                elseif index_i_parent2 == length(parent2)
                    edge_table.(field) = [parent1(index_i_parent1-1), parent1(index_i_parent1+1), parent2(index_i_parent2-1) parent2(1)];
                else
                    edge_table.(field) = [parent1(index_i_parent1-1), parent1(index_i_parent1+1), parent2(index_i_parent2-1) parent2(index_i_parent2+1)];
                end
            end
        end
        %% crossover operation

        % child
        remaining_cities = [1:size(OldChrom,2)];

        city = randi([1,length(OldChrom(1,:))]);
        for i=1:length(parent1)
            field = ['city' num2str(i)];
            edges = edge_table.(field);
            edge_table.(field) = edges(edges~=city);
        end
        field = ['city' num2str(city)];
        edges = edge_table.(field);
        child1 = [city];

        remaining_cities = remaining_cities(remaining_cities~=city);

        while ~isempty(remaining_cities)
            if length(unique(edges)) == length(edges)
                number_of_edges = [];
                for i=1:length(edges)
                    field = ['city' num2str(edges(i))];
                    list = edge_table.(field);
                    number_of_edges = [number_of_edges length(unique(list))];
                end
                if ~isempty(number_of_edges)
                    city = edges(datasample(find(number_of_edges == min(number_of_edges)),1));
                else
                    city = remaining_cities(randi([1,length(remaining_cities)],1,1));
                end
                child1 = [child1 city];
                for i=1:length(parent1)
                    field = ['city' num2str(i)];
                    edges = edge_table.(field);
                    edge_table.(field) = edges(edges~=city);
                end
                field = ['city' num2str(city)];
                edges = edge_table.(field);
                remaining_cities = remaining_cities(remaining_cities~=city);
            else
                common_edges = [];
                for i=1:length(edges)
                    if length(find(edges==edges(i)))>1
                        common_edges = [common_edges edges(i)];
                    end
                end
                common_edges = unique(common_edges);
                number_of_edges = [];
                for i=1:length(common_edges)
                    field = ['city' num2str(common_edges(i))];
                    list = edge_table.(field);
                    number_of_edges = [number_of_edges length(unique(list))];
                end
                if ~isempty(number_of_edges)
                    city = common_edges(datasample(find(number_of_edges == min(number_of_edges)),1));
                else
                    city = remaining_cities(randi([1,length(remaining_cities)],1,1));
                end
                child1 = [child1 city];
                for i=1:length(parent1)
                    field = ['city' num2str(i)];
                    edges = edge_table.(field);
                    edge_table.(field) = edges(edges~=city);
                end
                field = ['city' num2str(city)];
                edges = edge_table.(field);
                remaining_cities = remaining_cities(remaining_cities~=city);
            end
        end
        NewChrom = [parent1; child1];
    else
        NewChrom = OldChrom;
    end
end