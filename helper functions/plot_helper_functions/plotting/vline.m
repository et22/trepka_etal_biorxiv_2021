function vline(x, varargin)

% VLINE plot a vertical line in the current graph

abc = axis;
x = [x x];
y = abc([3 4]);
if length(varargin) == 0,
    varargin = {'color', [0.5 0.5 0.5]};
elseif length(varargin) == 1,
    varargin = {'color', varargin{1}};
end
h = line(x, y);
set(h, varargin{:});
