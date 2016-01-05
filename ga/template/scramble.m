function NewChrom = scramble(OldChrom,Representation)
    NewChrom=OldChrom;

    if Representation==1 
        NewChrom=adj2path(NewChrom);
    end
    
    positions_for_scramble = zeros(1,2);
    
    while positions_for_scramble(1)==positions_for_scramble(2)
        positions_for_scramble = randi([1 size(NewChrom,2)],1,2);
    end
    positions_for_scramble = sort(positions_for_scramble);
    
    offset = NewChrom(positions_for_scramble(1):positions_for_scramble(2));
    offset = offset(randperm(length(offset)));
    NewChrom(positions_for_scramble(1):positions_for_scramble(2)) = offset;
    
    if Representation==1
	NewChrom=path2adj(NewChrom);
    end