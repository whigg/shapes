classdef PointSet2D < Geometry2D
%POLYGON2D A set of points in the plane
%
%   Represents a set of vertices. 
%
%   Data are represented by a NV-by-2 array.
%
%   Example
%   PointSet2D([0 0; 10 0; 10 10]; 0 10]);
%
%   See also
%   Geometry2d, Polygon2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Properties
properties
    % the set of vertices, given as a N-by-2 array of coordinates
    vertices;
    
end % end properties


%% Constructor
methods
    function this = PointSet2D(varargin)
    % Constructor for PointSet2D class
    
        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 2) ~= 2
                error('Creating a point set requires an array with two columns, not %d', size(var1, 2));
            end
            this.vertices = var1;

        else
            this.vertices = [];
        end
    end

end % end constructors


%% Methods
methods
    function box = boundingBox(this)
        % Returns the bounding box of this shape
        box = Box2D(boundingBox(this.vertices));
    end
    
    function varargout = draw(this, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = drawPoint(this.vertices);
        if nargin > 1
            var1 = varargin{1};
            if isa(var1, 'Style')
                applyStyle(var1, h);
            end
        end
        
        if nargout > 0
            varargout = {h};
        end
    end
    
    function res = scale(this, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = PointSet2D(this.vertices * factor);
    end
    
    function res = translate(this, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = PointSet2D(bsxfun(@plus, this.vertices, shift));
    end
    
    function res = rotate(this, angle, varargin)
        % Returns a rotated version of this polygon
        %
        % POLY2 = rotate(POLY, THETA)
        % POLY2 = rotate(POLY, THETA, CENTER)
        % THETA is given in degrees, in counter-clockwise order.
        
        origin = [0 0];
        if ~isempty(varargin)
            origin = varargin{1};
        end
        
        rot = createRotation(origin, deg2rad(angle));
        verts = transformPoint(this.vertices, rot);
        
        res = PointSet2D(verts);
    end
end % end methods

end % end classdef

