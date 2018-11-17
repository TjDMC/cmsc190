%female = female in heat
%males = array of mating males
%muprob = mutation probability
%maxvalue = maximum value per dimension
%minvalue = minimum value per dimension
function offsprings = mate(female, males, muprob, maxvalue, minvalue)
    mean = 0.5; % mean
    sd = 0.1; % standard dev
    beta = normrnd(mean,sd);% crossover point
    
    o1 = Lion; % offspring 1
    o2 = Lion; % offspring 2
    o1.vector = [];
    o2.vector = [];
    %crossover
    for i=1:size(female.vector,1)    
        femgene = [0 0];
        femgene(1) = beta*female.vector(i); % female gene for o1
        femgene(2) = (1-beta)*female.vector(i); % female gene for o2
        malegene = [0 0];
        for i2=1:size(males,2)
            malegene(1) = malegene(1)+males(i2).vector(i)*(1-beta)/size(males,2); % male gene for o1
            malegene(2) = malegene(2)+males(i2).vector(i)*(beta)/size(males,2); % male gene for o2
        end
        o1.vector = [o1.vector; (malegene(1)+femgene(1))]; % offspring 1
        o2.vector = [o2.vector; (malegene(2)+femgene(2))]; % offspring 2
        
        %gender group
        if rand(1) <= 0.5
            o1.sex = 'm';
            o2.sex = 'f';
        else
            o1.sex = 'f';
            o2.sex = 'm';
        end
        
        %determine candidate for mutation (only 1 of the offspring can undergo mutation)
        if rand(1) <=0.5
            tomutate=o1;
        else
            tomutate=o2;
        end
        
        %mutation
        if rand(1) <= muprob
            tomutate.vector(i) = (maxvalue-minvalue)*rand()+minvalue;
        end

    end
    offsprings = [o1 o2];
end