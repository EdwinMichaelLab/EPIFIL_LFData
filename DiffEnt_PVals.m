

%% Description: to calculate differential entropy and save p-values

%% Input: Data files

%% Output: Differential entropy and p-values

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

model={'EPIFIL','TRANSFIL','LYMFASIM'}; % models
Scenario= 1:4;
Site = {'Kirare','Alagramam','Peneng'};
Code = {'A','B','C'}; % A = SSA, B = IND, C = PNG

for itype=1:length(model)
    
    % new file to save p values
    filename0 = sprintf('%s_DiffEntPVals.xlsx',model{itype});
    
    % initialize matrix
    entrp0 = zeros(length(Scenario)+1,length(Scenario)+1);
    
    for n =1:length(Site)
        
        NumRounds=[];
        
        % model only
        filename = sprintf('%s_modelonly_%s.xlsx',model{itype},Site{n});
        if exist(filename,'file')
            [num,txt,~]=xlsread(filename);
            fclose('all');
            colnum=2; % mf prev outputs start
            
            % number of parameter sets for each scenario
            id = 1:length(txt(:,1))-1;
            
            % calculate timelines to WHO 1% mf threshold
            k = 1;
            for i = id(1):id(end)
                T = find((num(i,colnum:50+colnum-1)) < 1);
                if ~isempty(T)
                    NumRounds(k,1) = T(1);
                    k = k+1;
                end
            end
            
            % original entropy
            entrp0(n,1) = Entropy(NumRounds(1:length(id),1));
        end
        
        % model+data
        filename = sprintf('%s_%s.xlsx',model{itype},Site{n});
        
        if exist(filename,'file')
            [num,txt,~]=xlsread(filename);
            fclose('all');
            colnum=2; % mf prev outputs start
            
            for iscen=1:length(Scenario)
                
                % number of parameter sets for each scenario, looks for
                % scenario code such as 'A1'
                if itype == 2 % these files used incorrect codes
                    id = find(strcmp(txt(:,2),sprintf('%s%s',Code{1},int2str(Scenario(iscen)))))-1;
                elseif itype == 3 % these files used incorrect codes and have an extra row in num
                    id = find(strcmp(txt(:,2),sprintf('%s%s',Code{1},int2str(Scenario(iscen)))));
                else
                    id = find(strcmp(txt(:,2),sprintf('%s%s',Code{n},int2str(Scenario(iscen)))))-1;
                end
                
                % calculate timelines to WHO 1% mf threshold
                k = 1;
                if itype == 2 % TRANSFIL
                    for i = id(1):id(end)
                        T = find((num(i,colnum:50+colnum-1)) < 0.01); % prev out of 1
                        if ~isempty(T)
                            NumRounds(k,iscen+1) = T(1);
                            k = k+1;
                        end
                    end
                else % EPIFIL and LYMFASIM
                    for i = id(1):id(end)
                        T = find((num(i,colnum:50+colnum-1)) < 1); % prev out of 100
                        if ~isempty(T)
                            NumRounds(k,iscen+1) = T(1);
                            k = k+1;
                        end
                    end
                end
                
                % record original entropy
                entrp0(n,iscen+1) = Entropy(NumRounds(:,iscen+1));
                
            end
            
            % original differential entropy
            dse0 = zeros(length(entrp0(1,:)),length(entrp0(1,:)));
            for i = 1:length(entrp0)
                for j = 1:length(entrp0)
                    dse0(i,j) = entrp0(n,i)-entrp0(n,j);
                end
            end
            
            % permutations
            nPerm = 20000;
            dse1 = zeros(nPerm,1);
            pVal = zeros(length(entrp0(1,:)),length(entrp0(1,:)));
            for i = 1:length(entrp0)
                for j = 1:length(entrp0)
                    x = nonzeros([NumRounds(:,i);NumRounds(:,j)]);
                    
                    a = length(nonzeros(NumRounds(:,i))); % how many to allocate to list 1
                    b = length(nonzeros(NumRounds(:,j))); % how many to allocate to list 2
                    
                    parfor m = 1:nPerm
                        % permute the list
                        id = randperm(length(x));
                        NumRounds1 = x(id(1:a),:);
                        NumRounds2 = x(id(a+1:a+b),:);
                        
                        % new entropies
                        entrp1 = Entropy(NumRounds1);
                        entrp2 = Entropy(NumRounds2);
                        dse1(m) = entrp1-entrp2;
                        
                    end
                    
                    % calculate p value
                    pVal(i,j) = length(find(abs(dse1)>abs(dse0(i,j))))/nPerm;
                end
            end
            
            % save to model-specific excel files
            if n == 1
                xlswrite(filename0,pVal,1,'A1');
            elseif n == 2
                xlswrite(filename0,pVal,1,'A7');
            elseif n == 3
                xlswrite(filename0,pVal,1,'A13');
            end
            
        end
        
        % trying to save memory...
        fclose('all');
        system('taskkill /F /IM EXCEL.EXE');
        clearvars num txt x dse1
    end
end






