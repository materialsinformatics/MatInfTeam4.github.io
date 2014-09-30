%
% Find edges of an image
%
%

function out = edgefinder()


close all;

% run a simple loop for now to go through all images and inspect
for i = 1:22

    file = ['J:\Users\Patxi\Dropbox\ME8333\22_S1\',num2str(i,'%1.0f'),'\multifocus.tif'];

    I = imread(file);
    
    % defines "fraction" of image to look at - useful for zooming in
    % on small patches [1e-5 to 1] represents the entire image
    start = 0.0000001;
    final = 1.0;
    I2 = I(ceil(start*size(I,1)):final*size(I,1),ceil(size(I,2)*start):final*size(I,2),:);

    G = rgb2gray(I2);

    %% canny filter
    filter1 = 'canny';
    thresh1 = [];

    BW1 = edge(G,filter1,thresh1);

    y = getmondim(1);
    h=figure('position',y);

    % plot original and the canny filters
    subplot(2,2,1);imshow(G); axis on;
    subplot(2,2,3); imshow(BW1); axis on; title([filter1,' filter, threshold = ',num2str(thresh1,'%1.2f')]);

    %% multi/single thresh no filter

    [levels metric] = multithresh(G,2); % get two levels
    levels = double(levels)/256;        % normalize

    BW1 = im2bw(G,levels(1));           % get pixels above first threshold
    BW2 = 1-im2bw(G,levels(2));         % get pixels below first threshold
    BW = BW1 & BW2; BW = 1- BW;         % get intersection and inverse
    figure(h);

    
    % plot the original image and overlay the thresholded image on top w gr
    green = cat(3,zeros(size(G)),ones(size(G)),zeros(size(G)));
    subplot(2,2,4); imshow(G);
    subplot(2,2,4); hold on; gh = imshow(green);
    title('multi-threshold');
    set(gh,'AlphaData',imcomplement(BW)); axis on;



    %% histogram
    [counts, x]=imhist(G);
    counts = counts*(1/sum(counts));    % normalize to get the ~pdf

    figure(h);
    subplot(2,2,2); 
    plot(x,counts); ys = get(gca,'Ylim'); hold on;
    plot([levels(1) levels(1)]*256,ys,'r');
    plot([levels(2) levels(2)]*256,ys,'r');
    ylim(ys);title(['m1 = ', num2str(metric,'%1.2f')]);
    axis on; grid on;
    set(gcf,'color','w');
    saveas(h,num2str(i,'%1.0d'),'png');
end