

%% Description: To calculate parameter constraint

%% Input: Excel files

%% Output: Results of parameter constraint for different scenarios
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model={'EPIFIL'}; % models
Scenario= 1:4;
Site = {'Kirare','Alagramam','Peneng'};
Code = {'A','B','C'}; % A = SSA, B = IND, C = PNG
NParams = 23;

c = zeros(length(Scenario)+1,length(Site));

for n =1%:length(Site)
    for itype=1%:length(model)
        
        % prior parameter ranges
        [~,maxParamVals,minParamVals] = Range_of_Parameters;
        if n == 1
            minParamVals = minParamVals-(0.5*minParamVals);
            maxParamVals = maxParamVals+(0.5*maxParamVals);
        end
        
        % model only
        filename = sprintf('%s_modelonly_%s.xlsx',model{itype},Site{n});
        if exist(filename,'file')
            [num,txt,~]=xlsread(filename);
            fclose('all');
            iscen = 0;
            id = 1:length((txt(:,1)))-1;
            
            j=1;
            s_prior = [];
            s_posterior = [];
            for i = 1:NParams(itype)% number of params
                if i ~= 15 % ignore VoverH, gets replaced in code with MBR/beta
                    
%                     
                    x2 = num(id,end-NParams(itype)+i);
%                    
                        s_prior(j) = ((maxParamVals(i)-minParamVals(i))/sqrt(12)); % prior uniform dist
                       
                        
                        s_posterior(j) = std(x2); % posterior empirical dist
                        
                        
                        j = j+1;
%                     
                end
                
                c(1,n) = mean(s_posterior)/mean(s_prior); % parameter constraint
            end
        end
        
        % model+data
        filename = sprintf('%s_%s.xlsx',model{itype},Site{n});
        
        if exist(filename,'file')
            
            % read file
            [num,txt,~]=xlsread(filename);
            fclose('all');
            
            % loop through scenarios 1-4
            for iscen=1:length(Scenario)
                
                % number of parameter sets for each scenario, looks for
                % scenario code such as 'A1'
                id = find(strcmp(txt(:,2),sprintf('%s%s',Code{n},int2str(Scenario(iscen)))))-1;
                
                % parameter sets
                
                j=1;
                s_prior = [];
                s_posterior = [];
                for i = 1:NParams% number of params
                    if i ~= 15 % ignore VoverH, gets replaced in code with MBR/beta
                        
                        x2 = num(id,end-NParams(itype)+i);
%                        
                            s_prior(j) = ((maxParamVals(i)-minParamVals(i))/sqrt(12)); % prior uniform dist
%                             
                            
                            s_posterior(j) = std(x2); % posterior empirical dist
%                             
                            
                            j = j+1;
%                       
                    end
                    
                    c(iscen+1,n) = mean(s_posterior)/mean(s_prior); % parameter constraint
                end
            end
        end
    end
end

% plot
plot(c(1:end,1),0:4,'-ro');
hold on;
plot(c(1:end,2),0:4,'-bo');
plot(c(1:end,3),0:4,'-ko');
set(gca, 'XDir','reverse');
set(gca, 'YDir','reverse');
set(gca,'YTick',0:4);
ylabel('Scenario');
xlabel('Parameter Constraint');






