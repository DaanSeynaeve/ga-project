% Main algorithm
% 
% Jasper Bau, Daan Seynaeve 2016
%
% parameters:
%
% x, y: coordinates of the cities
% REP: representation to use ('path' or 'adj')
% NIND: number of individuals
% MAXGEN: maximal number of generations
% ELITIST: percentage of elite population
% STOP_PERCENTAGE: percentage of equal fitness (stop criterium)
% PR_CROSS: probability for crossover
% PR_MUT: probability for mutation
% CROSSOVER: the crossover operator
% SUBPOP: No. of subpopulations
% MIGR: Migration rate
% MIGGEN: No. of gens / migration
% ah1, ah2, ah3: axes handles to visualise tsp
%
% returns: best-, mean- and worst-fitness w.r.t. gen
%
function [best,mean_fits,worst] = run_ga_adapted(...
    x, y, REP, NIND, MAXGEN, NVAR, ELITIST, STOP_PERCENTAGE, ...
    PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, ...
    SUBPOP, MIGR, MIGGEN, ...
    ah1, ah2, ah3)

    GGAP = 1 - ELITIST;
    stopN=ceil(STOP_PERCENTAGE*NIND);
    mean_fits=zeros(1,MAXGEN+1);
    worst=zeros(1,MAXGEN+1);
    best=zeros(1,MAXGEN);
    
    % distance matrix
    Dist=zeros(NVAR,NVAR);
    for i=1:size(x,1)
        for j=1:size(y,1)
            Dist(i,j)=sqrt((x(i)-x(j))^2+(y(i)-y(j))^2);
        end
    end
    
    % initialize population
    Chrom=zeros(NIND,NVAR);
    if strcmp(REP,'path');
        for row=1:NIND
            Chrom(row,:)=path2adj(randperm(NVAR));
        end
        ObjV = tspfun_path(Chrom,Dist);
    else
        for row=1:NIND
        Chrom(row,:)=randperm(NVAR);
        end
        ObjV = tspfun(Chrom,Dist);
    end
    
    % generational loop
    gen = 0;
    while gen<MAXGEN
        sObjV=sort(ObjV);
        best(gen+1)=min(ObjV);
        minimum=best(gen+1);
        mean_fits(gen+1)=mean(ObjV);
        worst(gen+1)=max(ObjV);
        for t=1:size(ObjV,1)
            if (ObjV(t)==minimum)
                break;
            end
        end

        pathData = Chrom(t,:);
        if strcmp(REP,'adj')
            pathData = adj2path(Chrom(t,:));
        end
        visualizeTSP(x,y,pathData, minimum, ah1, gen, best, mean_fits, worst, ah2, ObjV, NIND, ah3);

        % stop criterium
        if (sObjV(stopN)-sObjV(1) <= 1e-15)
              break;
        end
        
        % assign fitness values to entire population
        FitnV=ranking(ObjV);
        % select individuals for breeding
        SelCh=select('sus', Chrom, FitnV, GGAP, SUBPOP);

        if strcmp(REP,'path') % path representation
            % recombine individuals (crossover)
            SelCh = recombin_path(CROSSOVER,SelCh,PR_CROSS,Dist,SUBPOP);
            SelCh = mutateTSP_path(MUTATION,SelCh,PR_MUT);

            %evaluate offspring, call objective function
            ObjVSel = tspfun_path(SelCh,Dist);

            %reinsert offspring into population
            [Chrom, ObjV]=reins(Chrom,SelCh,SUBPOP,1,ObjV,ObjVSel);

            Chrom = tsp_ImprovePopulation_path(NIND, NVAR, Chrom,LOCALLOOP,Dist);
        else % adjacency representation
            % recombine individuals (crossover)
            SelCh = recombin(CROSSOVER,SelCh,PR_CROSS,SUBPOP);
            SelCh = mutateTSP('inversion',SelCh,PR_MUT);

            %evaluate offspring, call objective function
            ObjVSel = tspfun(SelCh,Dist);

            %reinsert offspring into population
            [Chrom, ObjV]=reins(Chrom,SelCh,SUBPOP,1,ObjV,ObjVSel);

            Chrom = tsp_ImprovePopulation(NIND, NVAR, Chrom,LOCALLOOP,Dist);
        end
        
        %increment generation counter
        gen=gen+1;
        
        % Migrate individuals between subpopulations
        if (rem(gen,MIGGEN) == 0)
            [Chrom, ObjV] = migrate(Chrom, SUBPOP, [MIGR, 1, 1], ObjV);
        end
    end
end