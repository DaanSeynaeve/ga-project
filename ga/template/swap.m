function NewChrom = swap(OldChrom,Representation)
    NewChrom=OldChrom;

    if Representation==1 
        NewChrom=adj2path(NewChrom);
    end
    
    positions_to_swap = zeros(1,2);
    
    while positions_to_swap(1)==positions_to_swap(2)
        positions_to_swap = randi([1 size(NewChrom,2)],1,2);
    end
    NewChrom(positions_to_swap) = NewChrom(flip(positions_to_swap));
    
    if Representation==1
	NewChrom=path2adj(NewChrom);
    end

end