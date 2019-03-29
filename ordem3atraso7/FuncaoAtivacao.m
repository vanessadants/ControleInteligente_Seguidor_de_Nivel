%Author: Vanessa Dantas de Souto Costa
%email: vanessa.dantas796@gmail.com

% Activation Function
function fx = FuncaoAtivacao(x,face)

%%%%%%%%%%%%%% definir a fun��o de ativa��o e sua derivada %%%%%%%%%%%%%%%
    
    if strcmpi(face,'LOGSIGMOIDE')
        %usamos como fun��o de ativa��o:LOG sigmoide
        %FA(X) = 1./(1+exp(-X))
        fx=1./(1+exp(-x));
    else
        if strcmpi(face,'TANGENTESIGMOIDE')
            %usamos como fun��o de ativa��o:tangente sigmoide
            %FA(X) = 2./(1+exp(-2.*X)) - 1;
            fx=2./(1+exp(-2.*x)) - 1;
        else
            disp('ERRO: fun��o de ativa��o n�o especificada');
            return;
        end
    end
    
end