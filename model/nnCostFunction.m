function [J, grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   output_layer_size, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices.

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)*2), ...
                 hidden_layer_size, (input_layer_size + 1)*2);

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1)*2)):end), ...
                 output_layer_size, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly
% J = 0;
% Theta1_grad = zeros(size(Theta1));
% Theta2_grad = zeros(size(Theta2));

% Part 1: Feedforward the neural network and return the cost in the
%         variable J. 

%������ΪXʱ��������������ÿһ������ֵ�����������Ϊa3����
X = [ones(m,1) X];%����ƫ����bias unit
a1 = X;
x_aver = Theta1(:,1:2:end);
sigma = Theta1(:,2:2:end);

z2 = zeros(m,hidden_layer_size);
for i=1:m
    for j=1:hidden_layer_size
        z2(i,j) = prod(exp(-(a1(i,:)-x_aver(j,:)).^2./sigma(j,:).^2),2);
    end
end

theta = 0;
% lamda = 0.7;
a2 = zeros(m,hidden_layer_size);
for i=1:m
    for j=1:hidden_layer_size
        if z2(i,j)-theta>=0
            a2(i,j) = z2(i,j);
        end
    end
end

a2 = [ones(size(a2,1),1) a2];
z3 = a2*Theta2';
a3 = z3./sum(a2,2);

%����CostFunction�����ֵJ��
J = (a3 - y)'*(a3 - y)/(2*m);

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. 

Delta1 = zeros(size(Theta1));
Delta2 = zeros(size(Theta2));

temp1 = zeros(size(Theta2));
for k=1:m
    for l=1:hidden_layer_size+1
        temp1(l) = ((a3(k)-y(k))./sum(a2(k),2)).*a2(k,l);
    end
    Delta2 = Delta2 +temp1;
end

temp1 = zeros(size(Theta2));
temp2 = zeros(size(Theta1));
for k=1:m
    for l=1:hidden_layer_size
        temp1(l+1) = ((a3(k)-y(k))./sum(a2(k),2)).*a2(k,l+1).*(Theta2(l+1)-y(k));
        for i=1:input_layer_size+1
            temp2(l,i*2-1) = temp1(l+1).*2*(X(k,i)-x_aver(l,i))./sigma(l,i).^2;
            temp2(l,i*2) = temp1(l+1).*2*(X(k,i)-x_aver(l,i)).^2./sigma(l,i).^3;
        end
    end
    Delta1 = Delta1 +temp2;
end

Theta1_grad = 1/m * Delta1;
Theta2_grad = 1/m * Delta2;

% Part 3: Implement regularization with the cost function and gradients.

temp1 = Theta1(:,2:end).*Theta1(:,2:end);
temp2 = Theta2(:,2:end).*Theta2(:,2:end);
J = J + lambda/(2*m)*(sum(temp1(:)) + sum(temp2(:)));
Theta1_grad(:,2:end) = Theta1_grad(:,2:end) + lambda/m .* Theta1(:,2:end);
Theta2_grad(:,2:end) = Theta2_grad(:,2:end) + lambda/m .* Theta2(:,2:end);

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];

end
