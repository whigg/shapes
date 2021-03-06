classdef Ellipse2D < Geometry2D
%ELLIPSE2D  One-line description here, please.
%
%   Class Ellipse2D
%
%   Example
%   Ellipse2D
%
%   See also
%     Circle2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-05-17,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    CenterX = 0;
    CenterY = 0;
    Radius1 = 1;
    Radius2 = 1;
    % The orientation in degrees, CCW
    Orientation = 0;
end % end properties


%% Constructor
methods
    function obj = Ellipse2D(varargin)
    % Constructor for Ellipse2D class

        switch nargin
            case 0
                % nothing to do
            case 1
                var1 = varargin{1};
                if size(var1, 2) ~= 5
                    error('Creating an ellipse requires an array with three columns, not %d', size(var1, 2));
                end
                obj.CenterX = var1(1);
                obj.CenterY = var1(2);
                obj.Radius1 = var1(3);
                obj.Radius2 = var1(4);
                obj.Orientation = var1(5);
        end
    end

end % end constructors


%% Methods specific to Ellipse2D
methods
    function center = center(obj)
        % returns the center of this circle as a Point2D
        center = Point2D(obj.CenterX, obj.CenterY);
    end
    
    function poly = asPolyline(obj, varargin)
        
        % determines number of points
        N = 72;
        if ~isempty(varargin)
            N = varargin{1};
        end
        
        % create time basis
        t = linspace(0, 2*pi, N+1)';
        t(end) = [];

        % angle of ellipse

        % get ellipse parameters
        xc = obj.CenterX;
        yc = obj.CenterY;
        r1 = obj.Radius1;
        r2 = obj.Radius2;
        theta = obj.Orientation;

        % pre-compute trig functions (angles is in degrees)
        cot = cosd(theta);
        sit = sind(theta);

        % position of points
        x = xc + r1 * cos(t) * cot - r2 * sin(t) * sit;
        y = yc + r1 * cos(t) * sit + r2 * sin(t) * cot;
        
        poly = LinearRing2D([x y]);
    end
end

%% Methods implementing the Geometry2D interface
methods
    function res = transform(obj, transform) %#ok<STOUT>
        % Applies a geometric transform to this geometry
        error('Transform not implemented for Circles');
    end
    
    function box = boundingBox(obj)
        % Returns the bounding box of this geometry
        extX = [obj.CenterX - obj.Radius obj.CenterX + obj.Radius];
        extY = [obj.CenterY - obj.Radius obj.CenterY + obj.Radius];
        box = Box2D([extX extY]);
    end
    
    function varargout = draw(obj, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = drawEllipse([obj.CenterX obj.CenterY obj.Radius1 obj.Radius2 obj.Orientation]);
        if nargin > 1
            var1 = varargin{1};
            if isa(var1, 'Style')
                apply(var1, h);
            end
        end
        
        if nargout > 0
            varargout = {h};
        end
    end
    
    function res = scale(obj, factor)
        % Returns a scaled version of this geometry
        res = Ellipse2D([[obj.CenterX obj.CenterY obj.Radius1 obj.Radius2] * factor obj.Orientation]);
    end
    
    function res = translate(obj, shift)
        % Returns a translated version of this geometry
        res = Ellipse2D([obj.CenterX+shift(1) obj.CenterY+shift(2) obj.Radius1 obj.Radius2 obj.Orientation]);
    end
    
    function res = rotate(obj, angle, varargin)
        % Returns a rotated version of this ellipse
        %
        % POLY2 = rotate(POLY, THETA)
        % POLY2 = rotate(POLY, THETA, CENTER)
        % THETA is given in degrees, in counter-clockwise order.
        
        center2 = rotate(center(obj), angle, varargin{:});
        res = Circle2D([center2.X center2.Y obj.Radius]);
    end
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'Circle2D', ...
            'center', [obj.CenterX obj.CenterY], ...
            'radius1', obj.Radius1, ...
            'radius2', obj.Radius2, ...
            'orientation', obj.Orientation);
    end
end
methods (Static)
    function circ = fromStruct(str)
        % Create a new instance from a structure
        circ = Ellipse2D([str.center str.radius1 str.radius2 str.orientation]);
    end
end


end % end classdef

