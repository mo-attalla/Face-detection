function face_detection_gui()
    fig = figure('Name', 'High-Precision Face Detection', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 900, 600], ...
                 'Color', [0.95 0.95 0.95]);

    ax = axes('Parent', fig, 'Units', 'pixels', ...
              'Position', [200, 80, 660, 480]);
    
    img = [];

    uicontrol('Style', 'pushbutton', 'String', 'Load Image', ...
              'Position', [30, 500, 120, 35], ...
              'FontSize', 10, ...
              'Callback', @loadImage);

    uicontrol('Style', 'pushbutton', 'String', 'Start Detection', ...
              'Position', [30, 440, 120, 35], ...
              'FontSize', 10, ...
              'Callback', @processImage);

    uicontrol('Style', 'pushbutton', 'String', 'Reset', ...
              'Position', [30, 380, 120, 35], ...
              'FontSize', 10, ...
              'Callback', @resetImage);

    uicontrol('Style', 'pushbutton', 'String', 'Exit', ...
              'Position', [30, 320, 120, 35], ...
              'FontSize', 10, ...
              'Callback', @(src,event) close(fig));

    function loadImage(~, ~)
        [file, path] = uigetfile({'*.png;*.jpg;*.jpeg', 'Image Files'});
        if isequal(file, 0), return; end
        img = imread(fullfile(path, file));
        axes(ax); imshow(img); title('Original Image', 'FontSize', 12);
    end

    function processImage(~, ~)
        if isempty(img)
            errordlg('Please load an image first.'); return;
        end

        % تنعيم قبل التحليل
        smoothImg = imgaussfilt(img, 1);

        % تحويل إلى YCbCr وتحليل مكونات الجلد
        ycbcr = rgb2ycbcr(smoothImg);
        y = ycbcr(:,:,1); cb = ycbcr(:,:,2); cr = ycbcr(:,:,3);
        skinMask = (cb >= 77 & cb <= 127) & (cr >= 133 & cr <= 173) & (y > 40);

        skinMask(round(end*0.6):end, :) = 0;
        skinMask = imfill(skinMask, 'holes');
        skinMask = bwareaopen(skinMask, 500);

        props = regionprops(skinMask, 'BoundingBox', 'Image', 'Eccentricity');

        axes(ax); imshow(img); hold on;
        for i = 1:length(props)
            patch = props(i).Image;
            [h, w] = size(patch);

            % قناع بيضاوي بنفس الحجم
            [X, Y] = meshgrid(1:w, 1:h);
            cx = w / 2; cy = h / 2;
            ellipseMask = ((X - cx).^2)/(w/2)^2 + ((Y - cy).^2)/(h/2)^2 <= 1;

            % تطابق مع القناع البيضاوي
            overlapRatio = sum(patch(:) & ellipseMask(:)) / sum(ellipseMask(:));

            % تماثل أفقي (نسبة الفرق بين نصفين)
            leftHalf = patch(:, 1:floor(w/2));
            rightHalf = fliplr(patch(:, end-floor(w/2)+1:end));
            if size(leftHalf,2) ~= size(rightHalf,2), continue; end
            symmetryScore = sum(leftHalf(:) == rightHalf(:)) / numel(leftHalf);

            % شروط قبول صارمة
            if overlapRatio > 0.6 && symmetryScore > 0.75 && props(i).Eccentricity < 0.92
                rectangle('Position', props(i).BoundingBox, ...
                          'EdgeColor', 'g', 'LineWidth', 2);
            end
        end
        title('High-Precision Detection Result', 'FontSize', 12);
    end

    function resetImage(~, ~)
        img = [];
        axes(ax); cla(ax); title('');
    end
end
