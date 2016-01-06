% script to perform various experiments without the GUI
%
% Daan Seynaeve 2016

addpath(genpath('.'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
REP = 'path'; % representation
NIND=200; % 50		% Number of individuals
MAXGEN=100; % 100		% Maximum no. of generations
% NVAR=26; %26		% No. of variables
PRECI=1; %1		% Precision of variables
ELITIST=0.05; %0.05    % percentage of the elite population
GGAP=1-ELITIST;	%1-ELITIST	% Generation gap
STOP_PERCENTAGE=.95; %.95   % percentage of equal fitness individuals for stopping
PR_CROSS=.95; % .95    % probability of crossover
PR_MUT=.35; % .05      % probability of mutation
LOCALLOOP=1; % 0     % local loop removal
CROSSOVER = 'scx';  % default crossover operator
MUTATION = 'inversion'; % default mutation operator
SUBPOP = 5; % No. of subpopulations
MIGR = 0.2; % Migration rate
MIGGEN = 20; % No. of gens / migration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load dataset
data = load('datasets/rbx711.tsp');
x=data(:,1)/max([data(:,1);data(:,2)]);y=data(:,2)/max([data(:,1);data(:,2)]);
NVAR=size(data,1);

% plot
figure('Name','TSP','Position',[50,100,1200,400]);
ah1 = subplot(1,3,1);
plot(x,y,'ko')
ah2 = subplot(1,3,2);
xlabel('Generation');
ylabel('Distance (Min. - Gem. - Max.)');
ah3 = subplot(1,3,3);
title('Histogram');
xlabel('Distance');
ylabel('Number');

% experiment 1: single run
[b,m,w] = run_ga_adapted(x, y, REP, NIND, MAXGEN, NVAR, ELITIST, ...
   STOP_PERCENTAGE, PR_CROSS, PR_MUT, CROSSOVER, MUTATION, LOCALLOOP, ...
   SUBPOP, MIGR, MIGGEN, ...
   ah1, ah2, ah3);

% experiment 2: comparing crossovers (ceteris paribus)
% cross = {'scx','pmx','cycle_cross','order_cross'};
% cross_bestfit = zeros(MAXGEN,length(cross));
% for i = 1:length(cross)
%     cross{i}
%     [b,m,w] = run_ga_adapted(x, y, REP, NIND, MAXGEN, NVAR, ELITIST, ...
%     STOP_PERCENTAGE, PR_CROSS, PR_MUT, cross{i}, MUTATION, LOCALLOOP, ...
%     SUBPOP, MIGR, MIGGEN, ...
%     ah1, ah2, ah3);
%     cross_bestfit(:,i) = b;
% end
% figure;
% plot(cross_bestfit);
% xlabel('Generation');
% ylabel('Best tour length');
% l = legend(cross);
% set(l,'Interpreter','none');



