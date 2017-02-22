function features = ML(image,options)
% Multi-Level Features
%   The image (original or descriptive) is used in order to get a Multi-Level representation from a set of grids (Multi-Block).
%	Usage:
%      features = PML(img)
%      features = PML(img, options)
%	Input:
%      image: Image matrix (M*N*L) of positive integer numbers.
%      options.level: Number of Multi-Block representations. (default: 4)
%      options.patterns:  (default: 256 for each channel).
%      options.representation: Displaying the representation. (default: false)
%   Output:
%      features: ML features
%   Author: Salah Eddine Bekhouche (salah@bekhouche.com)
%   Cite: Bekhouche, S. E., Ouafi, A., Benlamoudi, A., Taleb-Ahmed, A., & Hadid, A. (2015, May). Facial age estimation and gender classification using multi level local phase quantization. In Control, Engineering & Information Technology (CEIT), 2015 3rd International Conference on (pp. 1-4). IEEE.


%% Image size
[m,n,l] = size(image);

%% PML level
if (~isfield(options, 'level'))
    options.level = 4;
end

%% PML patterns
if (~isfield(options, 'patterns'))
    for i=1:l
        options.patterns(i) = 256;
    end
end

%% Representation
for i=1:options.level
    for j=1:l
        representation{i,j} = image(:,:,j);
    end
end

%% Features
%{%
counter = 0;
features = zeros(sum((1:options.level).^2)* sum(options.patterns),1);
for level=1:options.level
    [md,nd] = size(representation{level,1});
    h = floor(md/level);
    w = floor(nd/level);
    hl = mod(md,h);
    wl = mod(nd,w);
    
    for channel = 1:l
        for mm = 1:h:md-hl
            for nn = 1:w:nd-wl
                sub_block = representation{level,channel}(mm:mm+h-1,nn:nn+w-1,:);
                features((counter*options.patterns(channel))+1:(counter+1)*(options.patterns(channel))) = hist(sub_block(:),0:options.patterns(channel)-1);
                counter = counter + 1;
            end
        end
    end
    
end
%}

%% Representation display
if (isfield(options, 'representation'))
    % for each channel
    figure;
    for i=1:l
        for j=1:options.level
            subplot(l,options.level,i + (j-1)*l), imshow(image(:,:,i)); hold on;
            title(['C:' num2str(i) ' L:' num2str(j)]);
            % This part from : http://blogs.mathworks.com/steve/2007/01/01/superimposing-line-plots/
            for k = 1:floor(m/j):m
                x = [1 n];
                y = [k k];
                plot(x,y,'Color','r','LineStyle','-');
                plot(x,y,'Color','k','LineStyle',':');
            end
            
            for k = 1:floor(n/j):n
                x = [k k];
                y = [1 m];
                plot(x,y,'Color','r','LineStyle','-');
                plot(x,y,'Color','k','LineStyle',':');
            end
            hold off;
        end
    end
end


end

