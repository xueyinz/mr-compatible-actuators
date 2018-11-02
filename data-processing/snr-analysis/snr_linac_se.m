%% AMME4112
% Xue Yin Zhang
% 2018

clearvars;
close all;

saving = true;

%% file path

path = '.../chosen-data-linac-se/'; % put in your correct path
files = dir(strcat(path,'*.IMA'));

%% definitions

labels = {'Baseline',...
    'Air motor off', 'Air motor on',...
    'Ceramic motor off', 'Ceramic motor on',...
    'Cylinder off', 'Cylinder on',...
    'Encoder & linear slide',...
    'Stepper motor off', 'Stepper motor on'};

pairs = [
    4, 17;      % baseline
    2, 10;      % air motor off
    3, 11;      % air motor on
    5, 12;      % ceramic off
    6, 13;      % ceramic on
    8, 15;      % cylinder off
    9, 16;      % cylinder on
    7, 14;      % encoder and linear slide
    17, 19;     % stepper off
    18, 20];    % stepper on

% regions of interest
x_roi = 90:166;
y_roi = 90:166;

n_pairs = size(pairs, 1);
snr = zeros(1, n_pairs);

%% calculate SNR

for ii = 1:n_pairs
    
    file1 = files(pairs(ii, 1)).name;
    file2 = files(pairs(ii, 2)).name;
    
    % open dicom file
    info1 = dicominfo(strcat(path, file1));
    info2 = dicominfo(strcat(path, file2));
    IMG1 = dicomread(info1);
    IMG2 = dicomread(info2);
    
    % subtraction image
    IMG_diff_double = double(IMG1) - double(IMG2);
    
    % convert to the right range for storing as png
    IMG1_8 = uint8(255 * mat2gray(IMG1));
    IMG2_8 = uint8(255 * mat2gray(IMG2));
    
    % store images in files struct
    files(pairs(ii, 1)).img = IMG1;
    files(pairs(ii, 2)).img = IMG2;
    
    % calculate snr
    snr(ii) = sqrt(2) * mean(mean(IMG1(x_roi, y_roi))) / std2(IMG_diff_double(x_roi, y_roi));
    
    if (saving == true)
        
        % image 1
        imshow(IMG1, []);
        name = strcat('img_', labels{ii}, '_1.png');
        imwrite(IMG1_8, name, 'png');
        hold on;
        
        % saving an image of where ROI is located
        rectangle('Position',[90, 90, 76, 76],...
             'LineWidth', 1.5, 'LineStyle', '-', 'EdgeColor', 'r');
        F = getframe(gca);
        imwrite(F.cdata, 'ROI_1.png');

        % image 2
        imshow(IMG2, []);
        name = strcat('img_', labels{ii}, '_2.png');
        imwrite(IMG2_8, name, 'png');

        % subtraction image with ROI
        imshow(IMG_diff_double, 'DisplayRange', []);
        name = strcat('img_diff_', labels{ii}, '.png');
        imwrite(uint8(255 * mat2gray(IMG_diff_double)), name);
        rectangle('Position',[90, 90, 76, 76],...
             'LineWidth', 1.5, 'LineStyle', '-', 'EdgeColor', 'r');
        F = getframe(gca);
        imwrite(F.cdata, 'ROI_diff.png');
        
        % contrast adjusted image 1
        IMG1_8 = imadjust(IMG1_8, [0 0.3],[]);
        imshow(IMG1_8, []);
        name = strcat('img_', labels{ii}, '_contrast1.png');
        F = getframe(gca);
        imwrite(F.cdata, name, 'png');

    end
    
end

%% plotting

h = figure;
c = categorical(labels);
c = reordercats(c, {'Baseline',...
    'Air motor off', 'Air motor on',...
    'Ceramic motor off', 'Ceramic motor on',...
    'Cylinder off', 'Cylinder on',...
    'Encoder & linear slide',...
    'Stepper motor off', 'Stepper motor on'});

b = bar(c, snr, 'FaceColor','flat');
default_colours = get(gca,'colororder');
b.FaceColor = 'flat';
b.CData(1,:) = default_colours(1,:);
b.CData(2,:) = default_colours(2,:);
b.CData(3,:) = default_colours(2,:);
b.CData(4,:) = default_colours(3,:);
b.CData(5,:) = default_colours(3,:);
b.CData(6,:) = default_colours(4,:);
b.CData(7,:) = default_colours(4,:);
b.CData(8,:) = default_colours(5,:);
b.CData(9,:) = default_colours(6,:);
b.CData(10,:) = default_colours(6,:);

grid on;
ylabel('SNR');
title('SNR for each item tested on the 1.5T MRI-LINAC');

%% saving

set(h,'Units', 'Inches');
pos = get(h, 'Position');
set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);
print(h, 'snr_ingham', '-dpdf', '-r0');