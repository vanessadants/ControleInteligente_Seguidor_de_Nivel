%atraso --> atraso para o Sinal de Controle (inteiro)
%ordem --> ordem do sistema 
function [in, out,passoTempo]= seguidorNivel(ordem,atraso,tanque)

%carregar amostras coletadas
load('samples.mat');

%ans=[0 0 0 0 0 0;1 2 3 4 5 6;10 20 30 40 50 60;100 200 300 400 500 600];
%entrada nEntradas x nAmostras
%Tempo
%Sinal de Controle
%Nível do Tanque 1
%Nível do Tanque 2

%y1--> nível do tanque 1
%y2--> nível do tanque 2
%u --> Sinal de Controle (tensão) 

%criar vetores coluna
passoTempo=ans(1,2);
u=ans(2,:)';
y=ans(tanque+2,:)';



if(ordem==0 || ordem+atraso>=length(u))
    disp(['Por favor, passe como parametro ordem>=1 e ordem<' num2str(length(u))]);
    return;
end

%Atrasar a entrada dada a ordem
vetorYatrasos=zeros(length(y),ordem);
vetorUatrasos=zeros(length(u),ordem);
%atrasar
for j=1:ordem
    for i=1:length(u)
        vetorYatrasos(j+i,j)=y(i);
        vetorUatrasos(j+atraso+i,j)=u(i);
    end
end

%desconsiderar ordem+atraso amostras 
vetorYatrasos=vetorYatrasos((ordem+atraso+1):end,:);
vetorUatrasos=vetorUatrasos((ordem+atraso+1):end,:);
y=y((ordem+atraso+1):end);
u=u((ordem+atraso+1):end);

%cortar vetores
vetorYatrasos=vetorYatrasos(1:length(y),:);
vetorUatrasos=vetorUatrasos(1:length(u),:);

%criar entrada
in=zeros(length(u),2*ordem);


%in-->entrada, matriz nAmostras x nEntradas
%2 colunas pois teremos o nivel do Tanque e o Sinal de Controle, o Bias
%sera adicionado dentro da MLP
%o número de linhas depende do comprimento de y ou de u, pois refere ao
%numero de amostras

in=[vetorYatrasos vetorUatrasos];

%criar out --> saida desejada nAmostras x 1
out=[y];


end