function bgProb = CalBackgroundProbability(depth)

bgStrength = 1  - depth;
bgSigma = 0.1; %sigma for converting depth value to background probability
bgProb =  1 - exp(-bgStrength.^2 / (2 * bgSigma * bgSigma)); %Estimate bg probability
