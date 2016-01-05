function NewChrom = insert(OldChrom,Representation)
    NewChrom=OldChrom;

    if Representation==1 
        NewChrom=adj2path(NewChrom);
    end
    
    positions_for_insert = zeros(1,2);
    
    while positions_for_insert(1)==positions_for_insert(2)
        positions_for_insert = randi([1 size(NewChrom,2)],1,2);
    end
    positions_for_insert = sort(positions_for_insert);
    
    changing_part = NewChrom((positions_for_insert(1)+1):length(NewChrom));
    NewChrom = [NewChrom(1:positions_for_insert(1)) NewChrom(positions_for_insert(2)) changing_part(changing_part~=NewChrom(positions_for_insert(2)))];
    
    if Representation==1
	NewChrom=path2adj(NewChrom);
    end

end