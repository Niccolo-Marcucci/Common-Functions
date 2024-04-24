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

% useful only if we assume the disign is in the form 
% Substrate-(A - B)*N-X-X-X-...-External_Medium

function title = create_design_title(design_file)
load(design_file,'d_layers','idx_layers');
d_layers=round(d_layers*1e9);
[d1,n1] = prepare_multilayer(d_layers,idx_layers);
N=length(d1);
idx_dA=(d1==d1(2));
% idx_dB=(d_layers==d_layers(3));
period = diff(find(idx_dA));
period = period(1);
idx_d = zeros(length(d1),period);
N_periods = N;
for i = 1:period
    idx_d(:,i) = (d1==d1(i+1));
    periods = (diff(find(idx_d(:,i))));
    last_period = find(periods~=periods(1));
    if isempty(last_period)
        last_period = length(periods);
    end
    N_tmp = length(periods(1:last_period))+1;
    if N_tmp < N_periods
        N_periods = N_tmp;
    end
end

% if ( idx_layers(idx_dA)~=idx_layers(2)) | ...
%                 (idx_layers(idx_dA)~=idx_layers(2) )
%     error("this multilayer cannot be used with this function")
% end

% Na=sum(idx_dA);
% Nb=sum(idx_dB);
% if Na~=Nb
%     N_periods=min(Na,Nb);
% else
%     N_periods=Na;
% end

title_first = strcat("", idxToStr(n1(1))," -(" );

title_secnd = strcat("Thicknesses:  ~ -(" );

for i = 1:period

    closing_char = "-";
    if i == period
        closing_char = ")x";
    end
    title_first = strcat(title_first, idxToStr(n1(i+1)),closing_char);
    title_secnd = strcat(title_secnd, string(d1(i+1)),closing_char);
end
title_first = strcat(title_first,string(N_periods));
title_secnd = strcat(title_secnd,string(N_periods));

for i=1+period*N_periods+1:N-1
    idxToStr(n1(i))
    title_first = strcat(title_first,"- ",idxToStr(n1(i)));
    title_secnd = strcat(title_secnd,"- ",string(d1(i)));
end

title_secnd=strcat(title_secnd,"  nm");
title = [title_first;title_secnd];
end

% has to be updated to the expected meterial library
function str = idxToStr(value)
    x = real(value);
    if (1.44 <= x) &&  (x <= 1.47)
        str = "SiO_2";
    elseif (1.62 <= x) &&  (x <= 1.66)
        str = "Al_2O_3";
    elseif (2.3 <= x) &&  (x <= 2.6)
        str = "TiO_2";
    elseif x == 1.48
        str = "PMMA";
    elseif (1.95 <= x) &&  (x <= 2.2)
        str = "Ta_2O_5";
    elseif x == 1
        str = "Air";
    else
        str = strcat("fake",string(real(value)),"");
    end
end

        