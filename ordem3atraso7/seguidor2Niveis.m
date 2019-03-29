%atraso --> atraso para o Sinal de Controle (inteiro)
%ordem --> ordem do sistema 
function [in, out, passoTempo]= seguidor2Niveis(ordem,atraso)

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
y1=ans(3,:)';
y2=ans(4,:)';


if(ordem==0 || ordem+atraso>=length(u))
    disp(['Por favor, passe como parametro ordem>=1 e ordem<' num2str(length(u))]);
    return;
end


%Atrasar a entrada dada a ordem
vetorY1atrasos=zeros(length(y1),ordem);
vetorY2atrasos=zeros(length(y2),ordem);
vetorUatrasos=zeros(length(u),ordem);
%atrasar
for j=1:ordem
    for i=1:length(u)
        vetorY1atrasos(j+i,j)=y1(i);
        vetorY2atrasos(j+i,j)=y2(i);
        vetorUatrasos(j+atraso+i,j)=u(i);
    end
end

%desconsiderar ordem+atraso amostras 
vetorY1atrasos=vetorY1atrasos((ordem+atraso+1):end,:);
vetorY2atrasos=vetorY2atrasos((ordem+atraso+1):end,:);
vetorUatrasos=vetorUatrasos((ordem+atraso+1):end,:);
y1=y1((ordem+atraso+1):end);
y2=y2((ordem+atraso+1):end);
u=u((ordem+atraso+1):end);

%cortar vetores
vetorY1atrasos=vetorY1atrasos(1:length(y1),:);
vetorY2atrasos=vetorY2atrasos(1:length(y2),:);
vetorUatrasos=vetorUatrasos(1:length(u),:);

%criar entrada
in=zeros(length(u),3*ordem);


%in-->entrada, matriz nAmostras x nEntradas
%2 colunas pois teremos o nivel do Tanque e o Sinal de Controle, o Bias
%sera adicionado dentro da MLP
%o número de linhas depende do comprimento de y ou de u, pois refere ao
%numero de amostras

in=[vetorY1atrasos vetorY2atrasos vetorUatrasos];

%criar out --> saida desejada nAmostras x 1
out=[y1 y2];


end