%% Function: median, Entropy, var, prctile, vartestn, vartest2

%% Description: To extrat data from the Excel files and calculate
% elimination timelines, weighted variance, median, 95% elimination
% timelines, entropy, normalised entropy and perform F-test

%% Input: Excel files

%% Output: elimination timelines, weighted variance, median, 95% elimination
% timelines, entropy, normalised entropy and F test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

type={'Kirare','Alagramam','Peneng'}; % sites
Scenario={'A0','A1','A2','A3','A4'}; % scenarios

j=1;
k=2;
NumRounds=[];


x=zeros(20000,5);
x(:,:)=NaN;

%% to extract dtaa from Excel files
for itype=2%:length(type)
    if itype==1
       
        [num,txt,raw]=xlsread('LYMPHASIM_Kirare_new.xlsx');
        Scennum=[1 6471;  
            6472 7372;
            7373 7735;
            7736 7959;
            7960 8204];
        colnum=1;
    elseif itype==2
        
        [num,txt,raw]=xlsread('LYMPHASIM_INDIA_new.xlsx');
        Scennum=[1 6903;
            6904 9809;
            9810 11957;
            11958 13923;
            13924 16713];
         colnum=1;
       
    else 
        [num,txt,raw]=xlsread('LYMPHASIM_PNG_new.xlsx');
        Scennum=[1 4195;
            4196 7967;
            7968 9498;
            9499 11079;
            11080 12734];
        colnum=1;
    end
    
    
    
   
    
    for iscen=1:length(Scenario)
        
        %% calculate timelines to WHO 1% mf threshold
        for i=Scennum(iscen,j):Scennum(iscen,k)
            
            T = find((num(i,colnum:12:(50*12)+colnum-1)) < 1);
            
            if ~isempty(T)
                NumRounds(i,itype) = T(1);  
            else
                NumRounds(i,itype)=50;
               
            end  
            
        end
        
        
 %% Calculation of weighted variance
        Frequency=0;
        mean=0;
variance=0;
a=unique(NumRounds((Scennum(iscen,1):Scennum(iscen,2)),itype));
for i = 1:length(a)
        Frequency(i) = sum(NumRounds((Scennum(iscen,1):Scennum(iscen,2)),itype) == a(i));
end
for i=1:length(a)
    mean=mean+a(i)*Frequency(i);
end
Wmean(iscen,itype)=mean/sum(Frequency);
for i=1:length(a)
    variance=variance+Frequency(i)*(a(i)-Wmean(iscen,itype))^2;
end 
Wvariance(iscen,itype)=variance/(sum(Frequency)*((length(Frequency)-1)/length(Frequency)));

%% Calculation of 95 persentile elimination timelines, entropy, normalised entropy, median, variance
x1(iscen,itype)=prctile(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype),2.5);
x2(iscen,itype)=prctile(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype),97.5);
entrp(iscen,itype) = Entropy(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));
vari(iscen,itype) = var(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));

maxyear(iscen,itype) = max(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));

minyear(iscen,itype) = min(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));
medianyear(iscen,itype) = median(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));
entrp_norm(iscen,itype) = Entropy_normalised(NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype));



x(1:Scennum(iscen,2)-Scennum(iscen,1)+1,iscen) = NumRounds(Scennum(iscen,1):Scennum(iscen,2),itype);
    end
    
    %% F test for equal variance
    p1 = vartestn(x); % are all variances are equal?
    p2 = vartest2(x(:,1),x(:,2)); % are pairwise variances equal?
    p3 = vartest2(x(:,1),x(:,3));
    p4 = vartest2(x(:,1),x(:,4));
    p5 = vartest2(x(:,2),x(:,3));
    p6 = vartest2(x(:,2),x(:,4));
    p7 = vartest2(x(:,3),x(:,4));
save(sprintf('Data_%s_LYMPHASIM.mat',type{itype}),...
        'Wvariance','Wmean','x1','x2','entrp','vari','maxyear','minyear','medianyear','entrp_norm','x','p1','p2','p3','p4','p5','p6','p7','NumRounds');
end


