%Author: Vanessa Dantas de Souto Costa, Felipe Ferreira Barbosa, Paulo
%Correia


%treinamento
%variaveis para treinamento
nce=1;
nuce=15;
TA=0.000001;

epMax=1000;
emqTarget=0.00001;
percentrein=0.8;
alphaMomento=0.6;
face='LOGSIGMOIDE'; %opcoes 'LOGSIGMOIDE' e 'TANGENTESIGMOIDE'
ini=[];

%Gerar entrada e saida desejada com base nos dados gerados ao rodar a bomba
ordem=3;
atraso=7;
tanque=2;

[in,out,passoTempo]=seguidorNivel(ordem,atraso,tanque);

%dividir entre validacao e treinamento
%devemos pegar percentrein para treinamento e o restante para
%validacao
%percentual --> inidca quantos dados serão usados para treinamento e
%quantos para validacao
percentual=0.8;


%embaralhar colunas
[N p]=size(in);

inTreino =in(1:floor(percentual*N),:);
outTreino =out(1:floor(percentual*N),:);
inValidacao =in((floor(percentual*N)+1):end,:);
outValidacao =out((floor(percentual*N)+1):end,:);
in=inTreino;
out=outTreino;


%normalizar entradas
maximos=max(abs(in));
for i=1:length(maximos)
   in(:,i)=in(:,i)./maximos(i);
end

%normalizar saida desejada
maximoS=max(max(abs(out)));
out=out./maximoS;

%carregar variaveis
%load('ini.mat')
load('SaidasBackPropagation.mat');

%chamada da funcao de treinamento BackPropagation
%[Pesos,AtivacoesNos,saidas,EMQ,Epoca]=BackPropagation(in,out,nce,nuce,TA,face,ini,epMax,emqTarget,percentrein,alphaMomento);
EMQ=EMQ(1:Epoca);

%salvar variaveis
save('SaidasBackPropagation.mat','Pesos','AtivacoesNos','EMQ','saidas','Epoca');

%chamada da funcao para validacao

%normalizar entradas
maximos1=max(abs(inValidacao));
for i=1:length(maximos1)
   inValidacao(:,i)=inValidacao(:,i)./maximos1(i);
end

%normalizar saida desejada
maximoS1=max(max(abs(outValidacao)));
outValidacao=outValidacao./maximoS1;

%inValidacao=in;
%outValidacao=out;
[saidasValidacao]=MLPnetwork(inValidacao,AtivacoesNos,Pesos,face);

%desnormalizar saida
saidasValidacao=saidasValidacao.*maximoS1;
outValidacao=outValidacao.*maximoS1;
%plot das solicitacoes feitas pelo professor

%criar vetor de tempo para plot
tempo=[0:passoTempo:((length(in)-1)*passoTempo)]';
tempoValidacao=[0:passoTempo:((length(inValidacao)-1)*passoTempo)]';


%Erro Quadratico por epoca;
figure();
plot(EMQ);
title('Erro médio quadrático por Epoca');

%Erro de comparacao;
erroComp=saidasValidacao-outValidacao;
figure();
plot(erroComp);
title('Erro de comparacao entre o comportamento real da bomba e saida MLP');

%Grafico de comparacao;
figure();
hold on
title('Comparacao entre o comportamento real da bomba e saida MLP');
plot(tempoValidacao,outValidacao,'r');
plot(tempoValidacao,saidasValidacao,'b');
hold off

%Saida da rede neural;
figure();
plot(tempoValidacao,saidasValidacao,'b');
title('Saida MLP');

%Saida da funcao matematica;
figure();
plot(tempoValidacao,outValidacao,'r');
title('Comportamento real da bomba');