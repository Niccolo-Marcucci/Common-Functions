% Copyright 2020 Niccolò Marcucci <niccolo.marcucci@polito.it>
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function is used for deleting all the layers that are set to
% have zero thickness. Moreover, first (substrate) and last (air) are
% set to have zero thickness, so that computations can be perormed on
% the stack only.
% Dummy layers at end and beginning are removed (layers that have same
% index than air or substrate)

function [d,n,d1,d2] = prepare_multilayer(d,n)
    N_l = length(d);
    d1 = d(1);
    d2 = d(end);
    d(1) = 0;
    d(end) = 0;
    
    % remove dummy layers ant beginning and end
    i = 2;
    while (n(i)==n(1)) || (d(i)==0) % exit when encounter te first
        d(i)=0;                     % layer with n~=n(1), that has
        i=i+1;                        % definite thickness
    end	
    i = N_l-1;
    while (n(i)==n(end)) || (d(i)==0) 
        d(i)=0;
        i=i-1;
    end	    
    
    
    i = 2;
    while i<N_l
        N_l=length(d);
        if (d(i)==0)
            d_new=zeros(N_l-1,1);
            n_new=zeros(N_l-1,1);

            d_new(1:i-1)  =d(1:i-1);
            d_new(i:N_l-1)=d(i+1:N_l);
            n_new(1:i-1)  =n(1:i-1);
            n_new(i:N_l-1)=n(i+1:N_l);

            n = n_new;
            d = d_new;
            i = 2;
        else
            i = i+1;
        end
    end    
    if nargout < 3
            d(1) = d1;
            d(end) = d2;
    end        
end