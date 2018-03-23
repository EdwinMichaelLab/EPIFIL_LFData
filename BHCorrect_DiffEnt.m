%% Function: fdr_bh

%% Description: to Execute the Benjamini & Hochberg (1995) and the Benjamini &
%            Yekutieli (2001) procedure for controlling the false discovery 
%            rate (FDR) of a family of hypothesis tests

%% Input: Saved p-values

%% Output: Corrected diffrential entropy

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('./DiffEnt/');

model={'EPIFIL','TRANSFIL','LYMFASIM'}; % models
Site = {'Kirare','Alagramam','Peneng'};

% load saved p-values and use BH procedure for signficance

for itype=1%:length(model)
    
    for n =1:length(Site)
        
        
        % file with saved p values
        filename0 = sprintf('%s_%s_optCov_DiffEntPVals.xlsx',Site{n},model{itype});
        
        p = xlsread(filename0);
        
        
        p1 = [];
        for i = 1:length(p(:,1))-1
            for j = i+1:length(p(:,1))
                p1 = [p1;p(i,j)];
            end
        end
        % to Execute the Benjamini & Hochberg (1995) and the Benjamini &
%            Yekutieli (2001) procedure for controlling the false discovery 
%            rate (FDR) of a family of hypothesis tests
        [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p1,0.05,'dep');
        fprintf(1,'%s crit_p = %d\n',Site{n},crit_p);
        disp(h);
        
    end
    
end


