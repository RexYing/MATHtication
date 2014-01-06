%% Export data for current jaw
% 
% raw
% sampling
% cropped
%

docNode = com.mathworks.xml.XMLUtils.createDocument('mathtication');
docRootNode = docNode.getDocumentElement;
docRootNode.setAttribute('upper_jaw_name', 'upper_cropped-downsampled.ply');
docRootNode.setAttribute('lower_jaw_name', 'lower_cropped-downsampled.ply');

axesElem = docNode.createElement('axes');
docRootNode.appendChild(axesElem);

%% axes raw
axesSubElem = docNode.createElement('axes_raw');
axesElem.appendChild(axesSubElem);
axesLowerElem = docNode.createElement('lower');
axesUpperElem = docNode.createElement('upper');
axesSubElem.appendChild(axesLowerElem);
axesSubElem.appendChild(axesUpperElem);
for i = 1: 3
    % Lower Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axesLowerRaw(:, i)) ));
    axesLowerElem.appendChild(axis);
    
    % Upper Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axesUpperRaw(:, i)) ));
    axesUpperElem.appendChild(axis);
end
clearvars axesRawElem;

%% axes sample 
if exist('axesLowerSample', 'var')
    sampleSize = 2000;

    axesSubElem = docNode.createElement('axes_FM');
    axesSubElem.setAttribute('sample_size', int2str(sampleSize));
    axesElem.appendChild(axesSubElem);
    axesLowerElem = docNode.createElement('lower');
    axesUpperElem = docNode.createElement('upper');
    axesSubElem.appendChild(axesLowerElem);
    axesSubElem.appendChild(axesUpperElem);
    for i = 1: 3
        % Lower Raw
        axis = docNode.createElement('axis');
        axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
            axesLowerSample(:, i)) ));
        axesLowerElem.appendChild(axis);

        % Upper Raw
        axis = docNode.createElement('axis');
        axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
            axesUpperSample(:, i)) ));
        axesUpperElem.appendChild(axis);
    end
end

%% axes adaptive cropping
axesSubElem = docNode.createElement('axes_adaptive_crop');
% TODO: attribute ...
axesElem.appendChild(axesSubElem);
axesLowerElem = docNode.createElement('lower');
axesUpperElem = docNode.createElement('upper');
axesSubElem.appendChild(axesLowerElem);
axesSubElem.appendChild(axesUpperElem);
for i = 1: 3
    % Lower Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axesLowerCropped(:, i)) ));
    axesLowerElem.appendChild(axis);
    
    % Upper Raw
    axis = docNode.createElement('axis');
    axis.appendChild(docNode.createTextNode(sprintf('%f,%f,%f', ...
        axesUpperCropped(:, i)) ));
    axesUpperElem.appendChild(axis);
end

%% Output
xmlFileName = ['data/jaw1', '.xml'];
xmlwrite(xmlFileName, docNode);
type(xmlFileName);
