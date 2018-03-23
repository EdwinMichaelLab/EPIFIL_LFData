%% Function: kstest2, fdr_bh

%% Description: To perform pairwise KS test and correct the p-values by BH correction

%% Input: Excel files

%% Output: p-values for KW test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc;

addpath('./Results');

model={'EPIFIL','TRANSFIL','LYMFASIM'}; % models
Scenario= 1:4;
Site = {'Kirare','Alagramam','Peneng'};
Code = {'A','B','C'}; % A = SSA, B = IND, C = PNG

for n =1:length(Site)
    p = zeros(length(Scenario)+1,length(model));
    for itype=1:length(model)
        
        NumRounds=[];
        
        % model only
        if itype == 1 % EPIFIL
            filename = sprintf('%s_modelonly_%s.xlsx',model{itype},Site{n});
            [num,txt,~]=xlsread(filename);
            fclose('all');
            colnum=2; % mf prev outputs start
            
            % number of parameter sets for each scenario
            id = 1:length(txt(:,1))-1;
        elseif itype == 2 % TRANSFIL
            filename = sprintf('%s_modelonly_%s.xlsx',model{itype},Site{n});
            [num,txt,~]=xlsread(filename);
            num = [num(:,1),num(:,2:12:50*12+1),num(:,50*12+1:end)]; % only keep annual mf prev
            fclose('all');
            colnum=2; % mf prev outputs start
            
            % number of parameter sets for each scenario
            id = 1:length(txt(:,1))-1;
        elseif itype == 3 % LYMFASIM
            filename = sprintf('%s_%s.xlsx',model{itype},Site{n});
            [num,txt,~]=xlsread(filename);
            num = [(1:length(num(:,1)))',num(:,2:12:50*12+2),num(:,50*12+2:end)]; % only keep annual mf prev
            fclose('all');
            colnum=2; % mf prev outputs start
            id = find(strcmp(txt(:,2),sprintf('%s%s',Code{1},'0'))); % model only in same file as other scenarios
        end
        
        
        % calculate timelines to WHO 1% mf threshold
        k = 1;
        for i = id(1):id(end)
            if itype == 2 % TRANSFIL
                T = find((num(i,colnum:50+colnum-1)) < 0.01);
            else % EPIFIL and LYMFASIM
                T = find((num(i,colnum:50+colnum-1)) < 1);
            end
            if ~isempty(T)
                NumRounds(k,1) = T(1);
                k = k+1;
            end
        end
        
        
        % model+data
        filename = sprintf('%s_%s.xlsx',model{itype},Site{n});
        
        [num,txt,~]=xlsread(filename);
        if itype == 2 && n == 2 % TRANSFIL
            num = [num(:,1),num(:,2:12:50*12+1),num(:,50*12+1:end)]; % only keep annual mf prev
        elseif itype == 3 % LYMFASIM
            num = [(1:length(num(:,1)))',num(:,2:12:50*12+2),num(:,50*12+2:end)]; % only keep annual mf prev
        end
        fclose('all');
        colnum=2; % mf prev outputs start
        
        for iscen=1:length(Scenario)
            
            % number of parameter sets for each scenario, looks for
            % scenario code such as 'A1'
            if itype == 3 || (itype == 2 && n == 3)% this file used incorrect codes
                id = find(strcmp(txt(:,2),sprintf('%s%s',Code{1},int2str(Scenario(iscen)))))-1;
            else
                id = find(strcmp(txt(:,2),sprintf('%s%s',Code{n},int2str(Scenario(iscen)))))-1;
            end
            
            % calculate timelines to WHO 1% mf threshold
            k = 1;
            for i = id(1):id(end)
                if itype == 2 % TRANSFIL
                    T = find((num(i,colnum:50+colnum-1)) < 0.01); % prev out of 1
                else
                    T = find((num(i,colnum:50+colnum-1)) < 1); % prev out of 100
                end
                if ~isempty(T)
                    NumRounds(k,iscen+1) = T(1);
                    k = k+1;
                end
            end
        end
        
        NumRounds(NumRounds==0)=NaN;
        
        % pairwise KS tests
        m = 1;
        for j = 1:length(Scenario)
            for k = j+1:length(Scenario)+1
                [h,p(m,itype)] = kstest2(NumRounds(:,j),NumRounds(:,k));
                m = m + 1;
            end
        end
         % To execute the Benjamini & Hochberg (1995) and the Benjamini &
%            Yekutieli (2001) procedure for controlling the false discovery 
%            rate (FDR) of a family of hypothesis tests      
        [h, crit_p, adj_ci_cvrg, adj_p] = fdr_bh(p(:,itype),0.05,'dep');
        fprintf(1,'%s crit_p = %d\n',model{itype},crit_p);
        disp(h);
        
    end
end






