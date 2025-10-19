function cost = calculateCostFunction(power_metrics, load_metrics, config)
% Combine energy and loads into a single cost (lower is better)
if nargin<3, config = struct(); end
w1 = 0.7; w2 = 0.3;
if ~isfield(config,'ref_AEP'), config.ref_AEP = max(power_metrics.AEP,1); end
if ~isfield(config,'ref_DEL'), config.ref_DEL = max(load_metrics.DEL_total,1); end
termAEP = max(0,(config.ref_AEP - power_metrics.AEP)/config.ref_AEP);
termDEL = load_metrics.DEL_total/config.ref_DEL;
cost = w1*termAEP + w2*termDEL;
end
